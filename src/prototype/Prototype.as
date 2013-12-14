package prototype
{
    import Core.Random;

    import feathers.controls.Button;

    import main.Main;

    import prototype.entities.Evocation;
    import prototype.ui.EvocationBar;

    import prototype.ui.PlayerDisplay;

    import starling.display.Image;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;

    import treefortress.sound.SoundAS;

    public class Prototype extends Sprite
    {
        private var _quad:Quad;

        private var _leftScreen:Screen;
        private var _worldFirst:World;
        private var _worldSecond:World;
        private var _rightScreen:Screen;
        private var _world:WorldSync;
        private var _level:Level;

        public static var current:int = -1;
        private var _leftDisplay:PlayerDisplay;
        private var _rightDisplay:PlayerDisplay;
        private var _leftEvocation:EvocationBar;
        private var _rightEvocation:EvocationBar;

        public function Prototype()
        {
            current = WorldSync.FIRST;

            _level = new Level();

            _worldFirst = new World(_level);
            _worldSecond = new World(_level);
            _world = new WorldSync(_worldFirst, _worldSecond);
            _world.pickFirstPlayer(Random.intValue(0, 10000));
            _world.pickSecondPlayer(Random.intValue(0, 10000));

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            _leftScreen = new Screen(_worldFirst.first, _worldFirst, _world);
            _rightScreen = new Screen(_worldSecond.second, _worldSecond, _world);
            _rightScreen.x = this.stage.stageWidth / 2;

            this.addChild(_leftScreen);
            this.addChild(_rightScreen);

            _leftDisplay = new PlayerDisplay(_worldFirst.first);
            _rightDisplay = new PlayerDisplay(_worldSecond.second);
            _rightDisplay.x = this.stage.stageWidth / 2;

            this.addChild(_leftDisplay);
            this.addChild(_rightDisplay);

            _leftEvocation = new EvocationBar(_worldFirst.first);
            _leftEvocation.y = this.stage.stageHeight - 40;
            this.addChild(_leftEvocation);


            _rightEvocation = new EvocationBar(_worldSecond.second);
            _rightEvocation.x = this.stage.stageWidth / 2;
            _rightEvocation.y = this.stage.stageHeight - 40;
            this.addChild(_rightEvocation);
        }
    }
}
