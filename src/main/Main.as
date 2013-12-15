package main
{
    import Core.Random;
    import Core.Utility;

    import avmplus.typeXml;

    import feathers.controls.Button;
    import feathers.controls.text.TextFieldTextEditor;
    import feathers.controls.text.TextFieldTextRenderer;
    import feathers.themes.MinimalMobileTheme;

    import justpinegames.Logi.Console;
    import justpinegames.Logi.ConsoleSettings;

    import prototype.Assets;

    import prototype.Prototype;

    import starling.core.Starling;

    import starling.display.MovieClip;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
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
        private var t3:TextFieldTextEditor;

        public function Main()
        {

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        }

        private function createSimpleMenu():void
        {
            var server:Button = new Button();
            server.label = "Server";
            server.x = 320;
            server.y = 100;
            server.width = 80;
            this.addChild(server);

            var client:Button = new Button();
            client.label = "Client";
            client.x = 320;
            client.y = 200;
            client.width = 80;
            this.addChild(client);

            var hotseat:Button = new Button();
            hotseat.label = "Hotseat";
            hotseat.x = 320;
            hotseat.y = 350;
            hotseat.width = 80;
            this.addChild(hotseat);

            var mc1:MovieClip = new MovieClip(testAtlas.getTextures("s"), 3);
            mc1.x = 240;
            mc1.y = 100;
            this.addChild(mc1);

            var mc2:MovieClip = new MovieClip(testAtlas.getTextures("d"), 3);
            mc2.x = 440;
            mc2.y = 200;
            this.addChild(mc2);

            var t:TextFieldTextRenderer = new TextFieldTextRenderer();
            t.text = "This was used for testing, not really ment to be in the game:";
            t.x = 200;
            t.y = 320;
            this.addChild(t);

            var t2:TextFieldTextRenderer = new TextFieldTextRenderer();
            t2.text = "Enter server code:";
            t2.x = 270;
            t2.y = 170;
            this.addChild(t2);

            t3 = new TextFieldTextEditor();
            t3.text = "";
            t3.width = 100;
            t3.x = 390;
            t3.y = 170;
            this.addChild(t3);


            var mc3:MovieClip = new MovieClip(testAtlas.getTextures("s"), 3);
            mc3.x = 240;
            mc3.y = 350;
            this.addChild(mc3);

            var mc4:MovieClip = new MovieClip(testAtlas.getTextures("d"), 3);
            mc4.x = 440;
            mc4.y = 350;
            this.addChild(mc4);

            Starling.juggler.add(mc1);
            Starling.juggler.add(mc2);
            Starling.juggler.add(mc3);
            Starling.juggler.add(mc4);

            server.addEventListener(Event.TRIGGERED, onTriggeredServer);
            client.addEventListener(Event.TRIGGERED, onTriggeredClient);
            hotseat.addEventListener(Event.TRIGGERED, onTriggeredHotseat);

            this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:EnterFrameEvent):void
        {
            if (t3.parent) t3.setFocus();

        }

        private function onTriggeredHotseat(event:Event):void
        {
            this.removeChildren();
            isServer = true;
            startGame();
        }

        private function onTriggeredClient(event:Event):void
        {
            if (t3.text.toLowerCase() == "") return;

            t3.setFocus();

            this.removeChildren();
            connection = new P2PClient2(t3.text.toLowerCase());
            connection.addEventListener(P2PClient2.CONNECTED, function():void
            {
                startGame();
            });
        }

        private function onTriggeredServer(event:Event):void
        {
            this.removeChildren();
            isServer = true;

            var text:TextFieldTextRenderer = new TextFieldTextRenderer();

            function randomString():String
            {
                var code:String = "";

                var can:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i"];

                for (var i:int = 0; i < 6; i++) code += Random.arrayElement(can);

                return code;
            }

            var code:String = randomString();
            text.x = 200;
            text.y = 200;
            text.text = "Tell client to connect to: " + code;
            addChild(text);


            connection = new P2PClient2(code);
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
