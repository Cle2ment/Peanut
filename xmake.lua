-- xmake.lua — Peanut standalone build
-- Peanut is an application framework built with Dear ImGui + Vulkan + GLFW
-- For use as a submodule of RayTracing: build from the parent project's xmake.lua instead
set_project("Peanut")
set_version("1.1")
set_xmakever("2.7.5")

add_rules("mode.debug", "mode.release", "mode.releasedbg")

-- ── Vulkan SDK ──
local vulkan_sdk = os.getenv("VULKAN_SDK")
if not vulkan_sdk then
    raise("VULKAN_SDK not set. Install Vulkan SDK 1.4+ and set VULKAN_SDK env var.")
end

-- ── Peanut (static library) ──
target("Peanut")
    set_kind("static")
    set_languages("c++17")

    -- Framework source files
    add_files("Peanut/src/**.cpp")

    -- ImGui core + Vulkan/GLFW backends
    add_files(
        "vendor/imgui/imgui.cpp",
        "vendor/imgui/imgui_draw.cpp",
        "vendor/imgui/imgui_tables.cpp",
        "vendor/imgui/imgui_widgets.cpp",
        "vendor/imgui/imgui_demo.cpp",
        "vendor/imgui/backends/imgui_impl_vulkan.cpp",
        "vendor/imgui/backends/imgui_impl_glfw.cpp",
        {public = false}
    )

    -- GLFW (Windows only)
    add_files(
        "vendor/GLFW/src/context.c",
        "vendor/GLFW/src/init.c",
        "vendor/GLFW/src/input.c",
        "vendor/GLFW/src/monitor.c",
        "vendor/GLFW/src/platform.c",
        "vendor/GLFW/src/vulkan.c",
        "vendor/GLFW/src/window.c",
        "vendor/GLFW/src/egl_context.c",
        "vendor/GLFW/src/osmesa_context.c",
        "vendor/GLFW/src/null_init.c",
        "vendor/GLFW/src/null_joystick.c",
        "vendor/GLFW/src/null_monitor.c",
        "vendor/GLFW/src/null_window.c",
        "vendor/GLFW/src/win32_init.c",
        "vendor/GLFW/src/win32_joystick.c",
        "vendor/GLFW/src/win32_module.c",
        "vendor/GLFW/src/win32_monitor.c",
        "vendor/GLFW/src/win32_thread.c",
        "vendor/GLFW/src/win32_time.c",
        "vendor/GLFW/src/win32_window.c",
        "vendor/GLFW/src/wgl_context.c",
        {public = false}
    )

    -- Include paths
    add_includedirs(
        "Peanut/src",
        "vendor/imgui",
        "vendor/imgui/backends",
        "vendor/GLFW/include",
        "vendor/stb_image",
        "vendor/glm",
        vulkan_sdk .. "/Include"
    )

    -- Vulkan link
    add_links("vulkan-1")
    add_linkdirs(vulkan_sdk .. "/Lib")

    -- Windows
    if is_plat("windows") then
        add_defines("PN_PLATFORM_WINDOWS", "_GLFW_WIN32", "_CRT_SECURE_NO_WARNINGS")
        add_links("Dwmapi", "opengl32", "gdi32", "user32", "kernel32", "shell32")
    end

    -- Config defines
    add_defines("PN_DEBUG", { debug = true })
    add_defines("PN_RELEASE", { release = true })
    add_defines("PN_DIST", { releasedbg = true })

-- ── PeanutApp (example executable) ──
target("PeanutApp")
    set_kind("binary")
    set_languages("c++17")

    add_files("PeanutApp/src/**.cpp")
    add_deps("Peanut")

    -- Inherit Peanut's dependency include paths
    add_includedirs(
        "vendor/imgui",
        "vendor/imgui/backends",
        "vendor/GLFW/include",
        "vendor/glm",
        vulkan_sdk .. "/Include"
    )

    if is_plat("windows") then
        add_defines("PN_PLATFORM_WINDOWS")
    end

    add_defines("PN_DEBUG", { debug = true })
    add_defines("PN_RELEASE", { release = true })
    add_defines("PN_DIST", { releasedbg = true })
