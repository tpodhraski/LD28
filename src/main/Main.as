package main
{
    import feathers.controls.Button;
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
        public static var isServer:Boolean = false;
        public static var connection:P2PClient2;

        public function Main()
        {

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        }

        private function createSimpleMenu():void
        {
            var server:Button = new Button();
            server.label = "Server";
            server.width = 80;
            this.addChild(server);

            var client:Button = new Button();
            client.label = "Client";
            client.x = 100;
            client.width = 80;
            this.addChild(client);

            var hotseat:Button = new Button();
            hotseat.label = "Hotseat";
            hotseat.x = 200;
            hotseat.width = 80;
            this.addChild(hotseat);

            server.addEventListener(Event.TRIGGERED, onTriggeredServer);
            client.addEventListener(Event.TRIGGERED, onTriggeredClient);
            hotseat.addEventListener(Event.TRIGGERED, onTriggeredHotseat);
        }

        private function onTriggeredHotseat(event:Event):void
        {
            this.removeChildren();
            isServer = true;
            startGame();
        }

        private function onTriggeredClient(event:Event):void
        {
            this.removeChildren();
            connection = new P2PClient2();
            connection.addEventListener(P2PClient2.CONNECTED, function():void
            {
                startGame();
            });
        }

        private function onTriggeredServer(event:Event):void
        {
            this.removeChildren();
            isServer = true;
            connection = new P2PClient2();
            connection.addEventListener(P2PClient2.CONNECTED, function():void
            {
                startGame();
            });
        }

        private function onAddedToStage(event:Event):void
        {
            var theme:MinimalMobileTheme = new MinimalMobileTheme(this.stage, true);


            // Create Logi console
            var settings:ConsoleSettings = new ConsoleSettings();
            settings.traceEnabled = true;

            var console:Console = new Console(settings);
            this.stage.addChild(console);


            assets = new AssetManager();
            assets.enqueue(Assets);
            assets.loadQueue(function(ratio:Number):void
            {
                testAtlas = assets.getTextureAtlas("Testing");

                if (ratio == 1.0)
                {
                    createSimpleMenu();

                }
            });

        }

        private function startGame():void
        {
            _prototype = new Prototype();
            this.addChild(_prototype);
        }
    }
}
