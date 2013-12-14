package prototype
{
    import Core.Random;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import main.Main;

    import prototype.entities.evocations.Evocation;
    import prototype.entities.runes.Rune;
    import prototype.ui.EvocationBar;

    import prototype.ui.PlayerDisplay;
    import prototype.ui.RuneDisplay;

    import starling.display.Image;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;

    import treefortress.sound.SoundAS;

    public class Prototype extends LayoutGroup
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
        private var _leftRunes:RuneDisplay;
        private var _rightRunes:RuneDisplay;
        private var _fogOfWarFirst:FogOfWar;
        private var _fogOfWarSecond:FogOfWar;

        public function Prototype()
        {
            Evocation.init();
            Rune.init();

            current = WorldSync.FIRST;

            _level = new Level();

            this.layout = new AnchorLayout();

            var seed:int = Math.random() * 10000;

            _worldFirst = new World(_level, seed);
            _fogOfWarFirst = new FogOfWar(_level);
            _worldSecond = new World(_level, seed);
            _fogOfWarSecond = new FogOfWar(_level);
            _world = new WorldSync(_worldFirst, _worldSecond);
            _world.pickFirstPlayer(Random.intValue(0, 10000));
            _world.pickSecondPlayer(Random.intValue(0, 10000));



            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            _leftScreen = new Screen(_worldFirst.first, _worldFirst, _fogOfWarFirst, _world);
            _rightScreen = new Screen(_worldSecond.second, _worldSecond, _fogOfWarSecond, _world);
            _rightScreen.x = this.stage.stageWidth / 2;

            this.addChild(_leftScreen);
            this.addChild(_rightScreen);

            _leftDisplay = new PlayerDisplay(_worldFirst.first);

            _rightDisplay = new PlayerDisplay(_worldSecond.second, true);
            _rightDisplay.layoutData = new AnchorLayoutData(NaN, 0);

            this.addChild(_leftDisplay);
            this.addChild(_rightDisplay);

            _leftEvocation = new EvocationBar(_worldFirst.first, _worldSecond.first);
            _leftEvocation.y = this.stage.stageHeight - 40;
            this.addChild(_leftEvocation);


            _rightEvocation = new EvocationBar(_worldFirst.second, _worldSecond.second);
            _rightEvocation.x = this.stage.stageWidth / 2;
            _rightEvocation.y = this.stage.stageHeight - 40;
            this.addChild(_rightEvocation);

            _leftRunes = new RuneDisplay(_worldFirst.first);
            _leftRunes.y = 100;
            this.addChild(_leftRunes);


            _rightRunes = new RuneDisplay(_worldSecond.second);
            _rightRunes.layoutData = new AnchorLayoutData(NaN, 0);

            _rightRunes.y = 100;
            this.addChild(_rightRunes);

            var seperator:Quad = new Quad(8, this.stage.stageHeight, 0xcc0000);
            seperator.x = this.stage.stageWidth / 2 - seperator.width / 2;
            this.addChild(seperator);

            var seperatorInner:Quad = new Quad(4, this.stage.stageHeight, 0x222222);
            seperatorInner.x = this.stage.stageWidth / 2 - seperatorInner.width / 2;
            this.addChild(seperatorInner);


        }
    }
}
