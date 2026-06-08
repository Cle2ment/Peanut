#pragma once

#include <memory>

#ifdef PN_PLATFORM_WINDOWS

extern Peanut::Application* Peanut::CreateApplication(int argc, char** argv);
bool g_ApplicationRunning = true;

namespace Peanut {

	int Main(int argc, char** argv)
	{
		while (g_ApplicationRunning)
		{
			std::unique_ptr<Peanut::Application> app{ Peanut::CreateApplication(argc, argv) };
			app->Run();
		}

		return 0;
	}

}

#ifdef PN_DIST

#include <Windows.h>

int APIENTRY WinMain(HINSTANCE hInst, HINSTANCE hInstPrev, PSTR cmdline, int cmdshow)
{
	return Peanut::Main(__argc, __argv);
}

#else

int main(int argc, char** argv)
{
	return Peanut::Main(argc, argv);
}

#endif // PN_DIST

#endif // PN_PLATFORM_WINDOWS
