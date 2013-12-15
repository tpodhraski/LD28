package prototype
{
    import Core.Random;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.controls.text.TextFieldTextRenderer;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import flash.geom.Point;
    import flash.utils.Dictionary;

    import main.Main;

    import prototype.entities.evocations.Evocation;
    import prototype.entities.runes.Rune;
    import prototype.ui.EvocationBar;

    import prototype.ui.PlayerDisplay;
    import prototype.ui.RuneDisplay;
    import prototype.ui.Tooltip;

    import starling.display.DisplayObject;

    import starling.display.Image;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

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
        private var _shared:TextFieldTextRenderer;
        private var _tooltip:Tooltip;
        public static var descriptions:Dictionary;
        public static var titles:Dictionary;
        private var _lastTitle:String = null;
        private var _lastDescription:String = null;

        public function Prototype()
        {
            descriptions= new Dictionary();
            titles = new Dictionary();

            Evocation.init();
            Rune.init();

            current = WorldSync.FIRST;

            _level = new Level();

            this.layout = new AnchorLayout();

            var seed:int = 12312321;// Math.random() * 10000;

            _worldFirst = new World(_level, seed);
            _fogOfWarFirst = new FogOfWar(_level);
            _worldSecond = new World(_level, seed);
            _fogOfWarSecond = new FogOfWar(_level);
            _world = new WorldSync(_worldFirst, _worldSecond);
            _world.pickFirstPlayer(1000);
            _world.pickSecondPlayer(1000);



            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onChangeShared(event:Event):void
        {
            _shared.text = "Shared:" +_world.crystalPool.toString();
        }

        private function onAddedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            this.stage.addEventListener(TouchEvent.TOUCH, onTouch);

            _leftScreen = new Screen(_worldFirst.first, _worldFirst, _fogOfWarFirst, _world);
            _rightScreen = new Screen(_worldSecond.second, _worldSecond, _fogOfWarSecond, _world);
            _rightScreen.x = this.stage.stageWidth / 2;

            this.addChild(_leftScreen);
            this.addChild(_rightScreen);

            _leftDisplay = new PlayerDisplay(_worldFirst.first);
            _leftDisplay.x = 230;

            _rightDisplay = new PlayerDisplay(_worldSecond.second, true);
            _rightDisplay.layoutData = new AnchorLayoutData(NaN, 0);

            this.addChild(_leftDisplay);
            this.addChild(_rightDisplay);

            _leftEvocation = new EvocationBar(_worldFirst.first, _worldSecond.first, _world, true);
            _leftEvocation.y = this.stage.stageHeight - 40;
            this.addChild(_leftEvocation);


            _rightEvocation = new EvocationBar(_worldFirst.second, _worldSecond.second, _world, false);
            _rightEvocation.x = this.stage.stageWidth / 2;
            _rightEvocation.y = this.stage.stageHeight - 40;
            this.addChild(_rightEvocation);

            _leftRunes = new RuneDisplay(_worldFirst.first);
            _leftRunes.y = 200;
            this.addChild(_leftRunes);


            _rightRunes = new RuneDisplay(_worldSecond.second);
            _rightRunes.layoutData = new AnchorLayoutData(NaN, 0);

            _rightRunes.y = 200;
            this.addChild(_rightRunes);

            var seperator:Quad = new Quad(8, this.stage.stageHeight, 0xcc0000);
            seperator.x = this.stage.stageWidth / 2 - seperator.width / 2;
            this.addChild(seperator);

            var seperatorInner:Quad = new Quad(4, this.stage.stageHeight, 0x222222);
            seperatorInner.x = this.stage.stageWidth / 2 - seperatorInner.width / 2;
            this.addChild(seperatorInner);


            _shared = new TextFieldTextRenderer();
            _shared.x =320;
            _shared.y = 460;
            _shared.text = "Shared:" +_world.crystalPool.toString();
            this.addChild(_shared);

            _world.addEventListener(Event.CHANGE, onChangeShared);


        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(DisplayObject(event.target), TouchPhase.HOVER);

            trace(event.target)

            if (DisplayObject(event.target).parent) trace(DisplayObject(event.target).parent);

            function removeTooltip():void
            {

                if (_tooltip)
                {
                    _tooltip.removeFromParent();
                    _tooltip = null;

                    _lastTitle = null;
                    _lastDescription = null;
                }
            }

            if (touch)
            {

                var title:* = titles[event.target];
                var description:* = descriptions[event.target];

                if (title && description)
                {

                    if (title != _lastTitle || description != _lastDescription)
                    {
                        removeTooltip();

                        _tooltip = new Tooltip(title, description);
                        var location:Point = DisplayObject(event.target).localToGlobal(new Point(0, 0));

                        _tooltip.x = location.x;
                        _tooltip.y = 350;

                        this.stage.addChild(_tooltip);

                        _lastTitle = title;
                        _lastDescription = description;
                    }

                }
                else
                {
                    removeTooltip();

                }
            }
            else
            {
                removeTooltip();

            }


        }
    }
}
