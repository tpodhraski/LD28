package prototype.ui
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.text.TextFieldTextRenderer;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;

    import starling.display.Quad;

    public class PlayerDisplay extends LayoutGroup
    {
        private var _player:Player;

        public function PlayerDisplay(player:Player, alignRight:Boolean = false)
        {
            _player = player;

            this.layout = new VerticalLayout();
            if (alignRight) VerticalLayout(this.layout).horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;

            player.addEventListener(PlayerEvent.CHANGE, onChange);

            syncChanges();
        }

        private function onChange(event:PlayerEvent):void
        {
            syncChanges();
        }

        private function syncChanges():void
        {
            this.removeChildren();

            var horizontalLayout:HorizontalLayout = new HorizontalLayout();
            horizontalLayout.gap = 4;


            var healthGroup:LayoutGroup = new LayoutGroup();
            healthGroup.layout = horizontalLayout;

            var healthLabel:TextFieldTextRenderer = new TextFieldTextRenderer()
            healthLabel.background = true;
            healthLabel.backgroundColor = 0x333333;
            healthLabel.text = "Health:";
            healthGroup.addChild(healthLabel);

            for (var i:int = 0; i < _player.maxHealth; i++)
            {
                if (i < _player.health) healthGroup.addChild(new Quad(16, 16, 0xff0000));
                else                    healthGroup.addChild(new Quad(16, 16, 0x550000));
            }

            this.addChild(healthGroup);

            var damageGroup:LayoutGroup = new LayoutGroup();
            damageGroup.layout = horizontalLayout;

            var damageLabel:TextFieldTextRenderer = new TextFieldTextRenderer()
            damageLabel.background = true;
            damageLabel.backgroundColor = 0x333333;
            damageLabel.text = "Damage:";
            damageGroup.addChild(damageLabel);

            var damageValueLabel:TextFieldTextRenderer = new TextFieldTextRenderer()
            damageValueLabel.background = true;
            damageValueLabel.backgroundColor = 0x333333;
            damageValueLabel.text = _player.damage.toString();
            damageGroup.addChild(damageValueLabel);

            this.addChild(damageGroup);


            var goldGroup:LayoutGroup = new LayoutGroup();
            goldGroup.layout = horizontalLayout;

            var goldLabel:TextFieldTextRenderer = new TextFieldTextRenderer()
            goldLabel.background = true;
            goldLabel.backgroundColor = 0x333333;
            goldLabel.text = "Gold:";
            goldGroup.addChild(goldLabel);

            var goldValueLabel:TextFieldTextRenderer = new TextFieldTextRenderer()
            goldValueLabel.background = true;
            goldValueLabel.backgroundColor = 0x333333;
            goldValueLabel.text = _player.gold.toString();
            goldGroup.addChild(goldValueLabel);

            this.addChild(goldGroup);
        }
    }
}
