package prototype.objects.items
{
    import prototype.entities.Player;

    import starling.display.Image;
    import starling.textures.Texture;

    public class Item extends Image
    {
        public function Item(texture:Texture)
        {
            super(texture);
        }

        public function pickup(target:Player):void
        {

        }
    }
}
