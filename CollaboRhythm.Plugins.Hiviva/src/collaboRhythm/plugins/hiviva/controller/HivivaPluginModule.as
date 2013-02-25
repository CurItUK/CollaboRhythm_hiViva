package collaboRhythm.plugins.hiviva.controller
{
	import castle.flexbridge.reflection.ReflectionUtils;
	import collaboRhythm.shared.controller.apps.AppControllerInfo;
	import collaboRhythm.shared.model.services.IComponentContainer;
	import collaboRhythm.shared.pluginsSupport.IPlugin;

	import mx.modules.ModuleBase;

	public class HivivaPluginModule extends ModuleBase implements IPlugin
	{
		public function HivivaPluginModule()
		{
			super();
			trace("PWS Hiviva Plugin Module Constructor");
		}

		public function registerComponents(componentContainer:IComponentContainer):void
		{

			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(HivivaAppController).name ,
					AppControllerInfo , new AppControllerInfo(HivivaAppController));
		}
	}
}
