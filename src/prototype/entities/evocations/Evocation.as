package prototype.entities.evocations
{
    import starling.display.Image;
    import starling.textures.Texture;

    public class Evocation extends Image
    {
        public static const CODE:int = 0x47e4f6;

        public static var EVOCATIONS:Array;

        public var title:String;
        public var description:String;


        public static function init():void
        {
            EVOCATIONS = [EvocationJump, EvocationPowerStrike];
        }


        public function Evocation(texture:Texture)
        {
            super(texture);
        }
    }
}
