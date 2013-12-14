package prototype.entities.evocations
{
    import main.Main;

    public class EvocationPowerStrike extends Evocation
    {

        public static const title:String = "Power Strike"
        public static const description:String = "Smash those bastards more!";


        public function EvocationPowerStrike(terrainId:int)
        {
            super(Main.testAtlas.getTexture("Evocation"));
        }
    }
}
