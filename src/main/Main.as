package main
{
    import feathers.themes.MinimalMobileTheme;

    import prototype.Prototype;

    import starling.display.Quad;
    import starling.display.Sprite;

    public class Main extends Sprite
    {
        private var _prototype:Prototype;

        public function Main()
        {
            var theme:MinimalMobileTheme = new MinimalMobileTheme(this, false);
            _prototype = new Prototype();
            this.addChild(_prototype);
        }
    }
}
