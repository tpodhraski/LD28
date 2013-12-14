package prototype.entities.evocations
{
    import main.Main;

    public class EvocationJump extends Evocation
    {
        public static const title:String = "Jump"
        public static const description:String = "Allows you to reduce the chance of failing a jump.";

        public function EvocationJump(terrainId:int)
        {
            super(Main.testAtlas.getTexture("Evocation"));

        }
    }
}
