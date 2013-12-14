package main
{
    import feathers.themes.MinimalMobileTheme;

    import justpinegames.Logi.Console;
    import justpinegames.Logi.ConsoleSettings;

    import prototype.Assets;

    import prototype.Prototype;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;

    public class Main extends Sprite
    {
        private var _prototype:Prototype;

        public static var assets:AssetManager;
        public static var testAtlas:TextureAtlas;

        public function Main()
        {
            var theme:MinimalMobileTheme = new MinimalMobileTheme(this, true);

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            assets = new AssetManager();
            assets.enqueue(Assets);
            assets.loadQueue(function(ratio:Number):void
            {
                testAtlas = assets.getTextureAtlas("Testing");

                if (ratio == 1.0) startGame();
            });
        }

        private function onAddedToStage(event:Event):void
        {
            // Create Logi console
            var settings:ConsoleSettings = new ConsoleSettings();
            settings.traceEnabled = true;

            var console:Console = new Console(settings);
            this.stage.addChild(console);

        }

        private function startGame():void
        {
            _prototype = new Prototype();
            this.addChild(_prototype);
        }
    }
}
