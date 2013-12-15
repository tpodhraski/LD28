package prototype.entities.enemies
{
    import main.Main;

    public class EnemyEater extends Enemy
    {
        public static const CODE:int = 0xfe9c00;

        public function EnemyEater(terrain:int)
        {
            super(Main.testAtlas.getTexture("H"));

            this.damage = 1;
            this.health = 2;
            this.walk = 1;
            this.walkRecharge = 0;

        }
    }
}
