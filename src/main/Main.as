package main
{
    import feathers.themes.MinimalMobileTheme;

    import prototype.Assets;

    import prototype.Prototype;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;

    public class Main extends Sprite
    {
        private var _prototype:Prototype;

        public static var assets:AssetManager;
        public static var testAtlas:TextureAtlas;

        public function Main()
        {
            var theme:MinimalMobileTheme = new MinimalMobileTheme(this, false);

            assets = new AssetManager();
            assets.enqueue(Assets);
            assets.loadQueue(function(ratio:Number):void
            {
                testAtlas = assets.getTextureAtlas("Testing");

                if (ratio == 1.0) startGame();
            });
        }

        private function startGame():void
        {
            _prototype = new Prototype();
            this.addChild(_prototype);
        }
    }
}
