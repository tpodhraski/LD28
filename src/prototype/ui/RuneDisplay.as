package prototype.ui
{
    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;

    import flash.geom.Point;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;
    import prototype.entities.runes.Rune;

    import starling.display.DisplayObject;
    import starling.events.Event;

    import starling.events.Touch;

    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class RuneDisplay extends LayoutGroup
    {
        private var _player:Player;
        private var _runes:Array;
        private var _tooltip:Tooltip;

        public function RuneDisplay(player:Player)
        {
            _player = player;
            this.layout = new VerticalLayout();

            this.width = 64;

            _runes = [];

            _player.addEventListener(PlayerEvent.CHANGE, onChange);

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            sync();
        }

        private function onAddedToStage(event:Event):void
        {
            this.stage.addEventListener(TouchEvent.TOUCH, onTouch);

        }

        private function sync():void
        {
            this.removeChildren();

            _runes = [];

            for (var i:int = 0; i < Rune.RUNES.length; i++)
            {
                var rune:Button = new Button();
                rune.width = 64;
                rune.height = 32;
                rune.label = (Rune.RUNES[i]).title;


                var canBeCharged:Boolean = _player.canRuneBeCharged(i);
                if (canBeCharged) this.addChild(rune);

                _runes.push(rune);
            }
        }

        private function onChange(event:PlayerEvent):void
        {
            sync();
        }

        private function onTouch(event:TouchEvent):void
        {

            if (_tooltip)
            {
                _tooltip.removeFromParent();
                _tooltip = null;
            }

            var i:int = 0;
            for each (var button:Button in _runes)
            {
                var touch:Touch = event.getTouch(button, TouchPhase.HOVER);
                if (touch)
                {


                    _tooltip = new Tooltip(Rune.RUNES[i].title, Rune.RUNES[i].description);

                    var location:Point = button.localToGlobal(new Point(button.x + button.width + 4, 0));

                    _tooltip.x = location.x;
                    _tooltip.y = location.y;

                    if (location.x > 300)
                    {
                        _tooltip.x = 720 - 300;
                    }



                    this.stage.addChild(_tooltip);
                }

                i++;
            }

        }
    }
}
