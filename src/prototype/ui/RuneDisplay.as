package prototype.ui
{
    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;
    import prototype.entities.runes.Rune;

    public class RuneDisplay extends LayoutGroup
    {
        private var _player:Player;

        public function RuneDisplay(player:Player)
        {
            _player = player;
            this.layout = new VerticalLayout();

            this.width = 32;

            _player.addEventListener(PlayerEvent.CHANGE, onChange);

            sync();
        }

        private function sync():void
        {
            this.removeChildren();

            for (var i:int = 0; i < Rune.RUNES.length; i++)
            {
                var rune:Button = new Button();
                rune.width = 32;
                rune.height = 32;
                rune.label = (Rune.RUNES[i]).title;

                var canBeCharged:Boolean = _player.canRuneBeCharged(i);
                if (canBeCharged) this.addChild(rune);
            }
        }

        private function onChange(event:PlayerEvent):void
        {
            sync();
        }
    }
}
