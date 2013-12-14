package prototype.objects.items
{
    import prototype.entities.Player;

    import starling.display.Image;
    import starling.textures.Texture;

    public class Item extends Image
    {
        public var title:String;
        public var description:String;


        public function Item(texture:Texture)
        {
            super(texture);
        }

        public function pickup(target:Player):void
        {

        }
    }
}
