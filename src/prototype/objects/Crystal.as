package prototype.objects
{
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;

    import main.Build;
    import main.Main;

    import starling.display.Image;
    import starling.events.Event;

    public class Crystal extends Sprite
    {
        public static const CODE:int = 0x25f5ae;

        private var _charged:Boolean = false;

        private var _image:Image;
        private var _counter:Number = 0;

        public function Crystal(terrainId:int)
        {
            var image:Image = new Image(Main.testAtlas.getTexture("Crystal"));
            image.pivotY = image.height - Build.CELL_HEIGHT;
            this.addChild(image)


        }


        public function get charged():Boolean
        {
            return _charged;
        }

        public function charge():void
        {
            if (_charged) return;

            _charged = true;

            _image = new Image(Main.testAtlas.getTexture("CrystalLight"));
            _image.pivotY = _image.height - Build.CELL_HEIGHT;
            this.addChild(_image);

            this.addEventListener(EnterFrameEvent.ENTER_FRAME, function(event:EnterFrameEvent): void
            {
                _image.alpha = (1 + Math.sin(_counter * 4)) * 0.5 + 0.5;
                _counter += event.passedTime;
            })

        }
    }
}
