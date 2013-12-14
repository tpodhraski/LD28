package prototype.entities
{
    import flash.utils.Dictionary;

    import main.Main;

    import starling.display.Image;

    public class Player extends Image
    {
        public static const SPAWN_FIRST:uint = 0xff00fc;
        public static const SPAWN_SECOND:uint = 0x0066ff;
        private var _second:Boolean;

        private var _health:int;
        private var _damage:int;
        private var _gold:int;
        private var _evocations:Dictionary;

        public static const EVOCATIONS:Array = [EvocationJump];

        public function Player(second:Boolean = false)
        {
            super(Main.testAtlas.getTexture(second ? "J" : "I"));
            _second = second;

            _evocations = new Dictionary();

            this.health = 3;
            this.damage = 1;
            this.gold = 0;
        }

        public function get health():int
        {
            return _health;
        }

        public function set health(value:int):void
        {
            _health = value;
            this.dispatchEvent(new PlayerEvent());
        }

        public function get damage():int
        {
            return _damage;
        }

        public function set damage(value:int):void
        {
            _damage = value;
            this.dispatchEvent(new PlayerEvent());
        }

        public function get gold():int
        {
            return _gold;
        }

        public function set gold(value:int):void
        {
            _gold = value;
            this.dispatchEvent(new PlayerEvent());

        }

        public function addEvocation(name:int, quantity:int = 1):void
        {
            if (!(name in _evocations)) _evocations[name] = 0;

            _evocations[name] += quantity;
            this.dispatchEvent(new PlayerEvent());

        }

        public function useEvocation(name:int):void
        {
            if (!(name in _evocations)) _evocations[name] = 0;

            _evocations[name]--;
            this.dispatchEvent(new PlayerEvent());

        }

        public function getEvocationCount(name:int):int
        {
            if (!(name in _evocations)) _evocations[name] = 0;
            return _evocations[name];
        }
    }
}
