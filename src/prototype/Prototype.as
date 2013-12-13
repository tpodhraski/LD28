package prototype
{
    import feathers.controls.Button;

    import main.Main;

    import starling.display.Image;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;

    import treefortress.sound.SoundAS;

    public class Prototype extends Sprite
    {
        private var _quad:Quad;

        public function Prototype()
        {
            _quad = new Quad(100, 100);
            this.addChild(_quad);

            var tile:Image = new Image(Main.testAtlas.getTexture("A"));
            this.addChild(tile);

            SoundAS.addSound("beep", new Assets.Beep());

            var button:Button = new Button();
            button.label = "Test";
            button.x = 200;
            button.y = 200;
            button.addEventListener(Event.TRIGGERED, onTriggered);
            this.addChild(button);
        }

        private function onTriggered(event:Event):void
        {
            _quad.rotation += 0.1;
            _quad.x += 10;
            _quad.y += 10;

           SoundAS.play("beep");
        }
    }
}
