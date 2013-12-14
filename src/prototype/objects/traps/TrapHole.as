package prototype.objects.traps
{
    import main.Main;

    import prototype.entities.Player;

    public class TrapHole extends Trap
    {
        public static const CODE:int = 0x7b0202;

        public function TrapHole(terrainId:int)
        {
            super(Main.testAtlas.getTexture("G"));
        }

        override public function apply(player:Player):void
        {
            super.apply(player);

            player.health -= 1;
        }
    }
}
