package prototype.ui
{
    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.LayoutGroup;
    import feathers.core.ToggleGroup;
    import feathers.layout.HorizontalLayout;

    import flash.utils.Dictionary;

    import prototype.entities.evocations.Evocation;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;

    import starling.events.Event;

    public class EvocationBar extends LayoutGroup
    {
//        private var _buttonGroup:ButtonGroup;
        private var _player:Player;

        private var evocationToButton:Dictionary;
        private var _toggleGroup:ToggleGroup;
        private var _playerOther:Player;

        public function EvocationBar(player:Player, playerOther:Player)
        {
            _player = player;
            _playerOther = playerOther;
            this.layout = new HorizontalLayout();


            evocationToButton = new Dictionary();

            _toggleGroup = new ToggleGroup();
            _toggleGroup.isSelectionRequired = false;
            _toggleGroup.addEventListener(Event.CHANGE, onButtonChange);

//
//            _buttonGroup = new ButtonGroup();

            var i:int = 0;
            for each (var evocation:Class in Evocation.EVOCATIONS)
            {
                var button:Button = new Button();
                button.isToggle = true;
                button.width = 60;
                button.height = 40;


                evocationToButton[i] = button;

                _toggleGroup.addItem(button);

//                function makeCallback(id:int):Function
//                {
//                    return function(event:Event):void
//                    {
//                        buttonClick(id, event);
//                    };
//                }
//
//                button.addEventListener(Event.TRIGGERED, makeCallback(i));

                i++;
            }


            _player.addEventListener(PlayerEvent.CHANGE, onChange);
            _player.addEventListener(PlayerEvent.CHANGE, onChange);
            sync();

        }

        private function onButtonChange(event:Event):void
        {
            _player.activeEvocation = _toggleGroup.selectedIndex;
            _playerOther.activeEvocation = _toggleGroup.selectedIndex;
        }

        private function onChange(event:PlayerEvent):void
        {
            sync();

        }

        public function sync():void
        {
            this.removeChildren();

            var i:int = 0;
            for each (var evocation:Class in Evocation.EVOCATIONS)
            {
                var button:Button = evocationToButton[i];
                var count:int = _player.getEvocationCount(i);

                button.isEnabled = count > 0;
                button.label = count.toString() + evocation.title;

                if (count != -1) this.addChild(button);

                i++;
            }

            _toggleGroup.selectedIndex = _player.activeEvocation;
        }
    }
}
