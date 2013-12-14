package prototype.entities
{
    import flash.utils.Dictionary;

    import main.Main;

    import prototype.entities.evocations.Evocation;

    import prototype.entities.evocations.EvocationJump;
    import prototype.entities.evocations.EvocationPowerStrike;
    import prototype.entities.runes.Rune;
    import prototype.entities.runes.RuneLogic;
    import prototype.entities.runes.RuneLogic;

    import starling.display.Image;

    public class Player extends Image
    {
        public static const SPAWN_FIRST:uint = 0xff00fc;
        public static const SPAWN_SECOND:uint = 0x0066ff;
        private var _second:Boolean;

        private var _health:int;
        private var _maxHealth:int;
        private var _damage:int;
        private var _gold:int;
        private var _evocations:Dictionary;

        private var _activeEvocation:int = -1;
        private var _runes:Dictionary;

        public function Player(second:Boolean = false)
        {
            super(Main.testAtlas.getTexture(second ? "J" : "I"));
            _second = second;

            _evocations = new Dictionary();

            _runes = new Dictionary();

            this.maxHealth = 4;
            this.health = 3;
            this.damage = 1;
            this.gold = 0;
        }

        public function get currentEvocation():Class
        {
            if (_activeEvocation == -1) return null;
            return Evocation.EVOCATIONS[_activeEvocation];
        }

        public function get health():int
        {
            return _health;
        }

        public function set health(value:int):void
        {
            if (value <= 0)
            {
                log("Death!");
                _health = 0;
            }
            else
            {
                _health = Math.min(value, _maxHealth);
            }

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


        private function makeSureRuneIsCreated(name:int):RuneLogic
        {
            var rune:RuneLogic;

            if (!(name in _runes))
            {
                rune = new RuneLogic();
                rune.creates = Rune.RUNES[name];
                rune.current = 0;
                rune.quality = -1;
                rune.target = Rune.RUNES_COST[name];
                _runes[name] = rune;
            }
            else
            {
                rune = _runes[name];
            }

            return rune;
        }

        public function addRune(name:int, qunatity:Number = 1):void
        {
            var runeLogic:RuneLogic = makeSureRuneIsCreated(name);
            if (runeLogic.quality < 0 )
            {
                runeLogic.quality = 0;

            }
            else
            {
                if ("deactivateBonus" in runeLogic.creates) runeLogic.creates.deactivateBonus(this, runeLogic);
            }


            runeLogic.quality += qunatity;

            if ("activateBonus" in runeLogic.creates) runeLogic.creates.activateBonus(this, runeLogic);




            this.dispatchEvent(new PlayerEvent());


        }

        public function chargeRune(name:int, amount:int):void
        {
            var runeLogic:RuneLogic = makeSureRuneIsCreated(name);
            if (runeLogic.quality > 0)
            {
                if (runeLogic.increase(amount))
                {
                    addEvocation(Evocation.EVOCATIONS.indexOf(runeLogic.creates.creates));
                    this.dispatchEvent(new PlayerEvent());
                }

            }
        }

        public function canRuneBeCharged(name:int):Boolean
        {
            var runeLogic:RuneLogic = makeSureRuneIsCreated(name);

            if (runeLogic.quality > 0) return true;
            else                       return false;

        }

        public function chargeRunes(amount:int = 1):void
        {
            for (var i:int = 0; i < Rune.RUNES.length; i++) chargeRune(i, amount);
        }

        public function changeLocation(x:int, y:int):void
        {
            this.x = x;
            this.y = y;

            this.dispatchEvent(new PlayerEvent(PlayerEvent.CHANGE_LOCATION));

        }

        public function addEvocation(name:int, quantity:int = 1):void
        {
            if (!(name in _evocations)) _evocations[name] = 0;

            if (_evocations[name] == -1) _evocations[name] = 0;

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
            if (!(name in _evocations)) _evocations[name] = -1;
            return _evocations[name];
        }

        public function get activeEvocation():int
        {
            return _activeEvocation;
        }

        public function set activeEvocation(value:int):void
        {
            _activeEvocation = value;
            this.dispatchEvent(new PlayerEvent());

        }

        public function get maxHealth():int
        {
            return _maxHealth;
        }

        public function set maxHealth(value:int):void
        {
            _maxHealth = value;
            this.dispatchEvent(new PlayerEvent());

        }
    }
}
