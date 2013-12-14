package prototype.objects.traps
{
    import main.Main;

    import prototype.Xorshift;

    import prototype.entities.evocations.EvocationJump;

    import prototype.entities.Player;

    public class TrapHole extends Trap
    {
        public static const CODE:int = 0x7b0202;

        public function TrapHole(terrainId:int)
        {
            super(Main.testAtlas.getTexture("G"));

            this.chance = 0.5;
            this.damage = 1;
        }

        override public function apply(player:Player, random:Xorshift):Boolean
        {
            if (player.currentEvocation == EvocationJump)
            {
                log("Jumpped!");
                return false;
            }

            if (super.apply(player, random))
            {
                player.health -= this.damage;
                log("Bam!");
                return true;
            }

            log("Success!");
            return false;
        }
    }
}
