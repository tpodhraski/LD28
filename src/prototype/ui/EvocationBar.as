package prototype.ui
{
    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.LayoutGroup;
    import feathers.core.ToggleGroup;
    import feathers.layout.HorizontalLayout;

    import flash.geom.Point;

    import flash.utils.Dictionary;

    import prototype.Prototype;

    import prototype.WorldSync;

    import prototype.entities.evocations.Evocation;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;

    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class EvocationBar extends LayoutGroup
    {
//        private var _buttonGroup:ButtonGroup;
        private var _player:Player;

        private var evocationToButton:Dictionary;
        private var _toggleGroup:ToggleGroup;
        private var _playerOther:Player;
        private var _tooltip:Tooltip;

        private var _evocations:Array;
        private var _syncWorld:WorldSync;
        private var _first:Boolean;
        private var _transfer:Button;

        public function EvocationBar(player:Player, playerOther:Player, syncWorld:WorldSync, first:Boolean)
        {
            _player = player;
            _playerOther = playerOther;
            _syncWorld = syncWorld;
            _first = first;
            this.layout = new HorizontalLayout();


            evocationToButton = new Dictionary();

            _toggleGroup = new ToggleGroup();
            _toggleGroup.isSelectionRequired = false;
            _toggleGroup.addEventListener(Event.CHANGE, onButtonChange);

//
//            _buttonGroup = new ButtonGroup();

            _evocations = [];

            _transfer = new Button();
            _transfer.label = "Transfer";
            _transfer.width = 40;
            _transfer.height = 40;
            _transfer.addEventListener(Event.TRIGGERED, onTransfer);
            this.addChild(_transfer);

            var i:int = 0;
            for each (var evocation:Class in Evocation.EVOCATIONS)
            {
                var button:Button = new Button();
                button.isToggle = true;
                button.width = 60;
                button.height = 40;


                evocationToButton[i] = button;

                _evocations.push(button);
                _toggleGroup.addItem(button);

                Prototype.titles[button] = Evocation.EVOCATIONS[i].title;
                Prototype.descriptions[button] = Evocation.EVOCATIONS[i].description;


                i++;
            }


            _player.addEventListener(PlayerEvent.CHANGE, onChange);
//            _playerOther.addEventListener(PlayerEvent.CHANGE, onChange);
            sync();

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onTransfer(event:Event):void
        {

                _syncWorld.transfer(_first, _player.activeEvocation);

        }

        private function onAddedToStage(event:Event):void
        {
        }

        private function onButtonChange(event:Event):void
        {

                _syncWorld.setActiveEvocation(_first, _toggleGroup.selectedIndex);


        }

        private function onChange(event:PlayerEvent):void
        {
            sync();

        }

        public static const TRANSFER_PRICE:int = 1;

        public function sync():void
        {
            this.removeChildren(1);

            _transfer.isEnabled = (_player.activeEvocation != -1) && (_player.gold >= TRANSFER_PRICE);

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
