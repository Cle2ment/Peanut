#include "Peanut/Application.h"
#include "Peanut/EntryPoint.h"

#include "Peanut/Image.h"

class ExampleLayer : public Peanut::Layer
{
public:
	virtual void OnUIRender() override
	{
		ImGui::Begin("Hello");
		ImGui::Button("Button");
		ImGui::End();

		ImGui::ShowDemoWindow();
	}
};

Peanut::Application* Peanut::CreateApplication(int argc, char** argv)
{
	Peanut::ApplicationSpecification spec;
	spec.Name = "Peanut Example";

	Peanut::Application* app = new Peanut::Application(spec);
	app->PushLayer<ExampleLayer>();
	app->SetMenubarCallback([app]()
	{
		if (ImGui::BeginMenu("File"))
		{
			if (ImGui::MenuItem("Exit"))
			{
				app->Close();
			}
			ImGui::EndMenu();
		}
	});
	return app;
}