package prototype.entities.runes
{
    import main.Main;

    import prototype.entities.Player;

    import prototype.entities.evocations.EvocationJump;

    import starling.display.Image;

    public class RuneJump extends Rune
    {
        public static const title:String = "Jump Rune"
        public static const description:String = "Produces jump evocation.";

        public static const creates:Class = EvocationJump;

        public function RuneJump(terrainId:int)
        {
            super(Main.testAtlas.getTexture("Rune"));

            this.producesPerPartDivider = 10;
            this.produces = EvocationJump;
        }

        public static function deactivateBonus(player:Player, logic:RuneLogic):void
        {
            player.maxHealth -= logic.quality;
        }

        public static function activateBonus(player:Player, logic:RuneLogic):void
        {
            player.maxHealth += logic.quality;
        }

    }
}
