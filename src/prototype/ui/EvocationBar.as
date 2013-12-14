package prototype.ui
{
    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.LayoutGroup;
    import feathers.layout.HorizontalLayout;

    import prototype.entities.Evocation;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;

    public class EvocationBar extends LayoutGroup
    {
        private var _buttonGroup:ButtonGroup;
        private var _player:Player;

        public function EvocationBar(player:Player)
        {
            _player = player;
            this.layout = new HorizontalLayout();

            _buttonGroup = new ButtonGroup();

            _player.addEventListener(PlayerEvent.CHANGE, onChange);
            sync();

        }

        private function onChange(event:PlayerEvent):void
        {
            sync();

        }

        public function sync():void
        {
            this.removeChildren();

            for each (var evocation:Class in Player.EVOCATIONS)
            {
                var code:int = evocation.CODE;

                var count:int = _player.getEvocationCount(code);

                var button:Button = new Button();

                button.width = 60;
                button.height = 40;
                button.label = count.toString() + evocation.title;

                this.addChild(button);


            }
        }
    }
}
