package prototype.entities.runes
{
    import prototype.entities.Player;
    import prototype.entities.evocations.Evocation;

    import starling.display.Image;
    import starling.textures.Texture;

    public class Rune extends Image
    {
        public var title:String;
        public var description:String;


        public var producesPerPartDivider:Number;
        public var produces:Class;

        public var current:int = 0;

        public static const CODE:int = 0xcbd681;

        public static var RUNES:Array;
        public static var RUNES_COST:Array;

        public function Rune(texture:Texture)
        {
            super(texture);
        }

        public static function init():void
        {
            RUNES =      [RuneJump];
            RUNES_COST = [       3];
        }

        public function produce(player:Player, quantity:int):void
        {
            if (!produces)
            {
                log("producess class is wrong!");
                return;
            }

            current += quantity;
            if (current >= producesPerPartDivider)
            {
                player.addEvocation(Evocation.EVOCATIONS.indexOf(produces))
                current = 0;
            }
        }


    }

}
