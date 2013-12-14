package prototype.ui
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.text.TextFieldTextRenderer;
    import feathers.layout.VerticalLayout;

    public class Tooltip extends LayoutGroup
    {
        public function Tooltip(title:String, description:String)
        {
            this.touchable = false;

            this.width = 200;

            var vertical:VerticalLayout = new VerticalLayout();
            vertical.gap = 4;
            vertical.padding = 10;
            this.layout = vertical;

            var titleText:TextFieldTextRenderer = new TextFieldTextRenderer();
            titleText.text = title;
            titleText.backgroundColor = 0x000000;
            titleText.background = true;
            this.addChild(titleText);

            var descriptionText:TextFieldTextRenderer = new TextFieldTextRenderer();
            descriptionText.width = 200;

            descriptionText.wordWrap = true;
            descriptionText.text = description;
            descriptionText.backgroundColor = 0x000000;
            descriptionText.background = true;
            this.addChild(descriptionText);

        }
    }
}
