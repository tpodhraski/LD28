package prototype
{
    import Core.Random;
    import Core.Utility;

    import prototype.entities.evocations.Evocation;
    import prototype.entities.evocations.EvocationJump;

    import prototype.entities.Player;
    import prototype.entities.runes.Rune;
    import prototype.objects.Crystal;
    import prototype.objects.items.Item;
    import prototype.objects.traps.Trap;
    import prototype.objects.Wall;

    import starling.display.DisplayObject;

    public class WorldSync
    {
        public static const FIRST:int = 1;
        public static const SECOND:int = 2;
        private var _worldFirst:World;
        private var _worldSecond:World;

        public function WorldSync(worldFirst:World, worldSecond:World)
        {
            _worldFirst = worldFirst;
            _worldSecond = worldSecond;

            _worldFirst.addEventListener(WorldEvent.CELL_SELECTED, onCellSelected);
            _worldSecond.addEventListener(WorldEvent.CELL_SELECTED, onCellSelected);
        }

        private function onCellSelected(event:WorldEvent):void
        {
//            if (event.primary) other(event.world).stimulatePoint(event.x, event.y, false);

            function playerSelector(world:World):Player
            {
                return (event.world == _worldFirst) ? player(world) : playerOther(world);
            }

            var canMove:Boolean = true;


            var eventPositionX:Number = event.x * 32;
            var eventPositionY:Number = event.y * 32;

            var directionX:Number = eventPositionX - playerSelector(_worldFirst).x;
            var directionY:Number = eventPositionY - playerSelector(_worldFirst).y;

            if (Math.abs(directionX) > Math.abs(directionY))
            {
                directionX = Utility.sign(directionX);
                directionY = 0;

            }
            else
            {
                directionX = 0;
                directionY = Utility.sign(directionY);
            }

            var newX:int = Math.floor(playerSelector(_worldFirst).x / 32) + directionX;
            var newY:int = Math.floor(playerSelector(_worldFirst).y / 32) + directionY;



            var object:DisplayObject = _worldFirst.objectAt(newX, newY);
            var objectOther:DisplayObject = _worldSecond.objectAt(newX, newY);

            if (object is Trap)
            {
                var trap:Trap = Trap(object);
                var trapOther:Trap = Trap(objectOther);

                trap.apply(playerSelector(_worldFirst), _worldFirst.random);
                trapOther.apply(playerSelector(_worldSecond), _worldSecond.random);
            }

            if (object is Item)
            {
                var item:Item = Item(object);
                var itemOther:Item = Item(objectOther);

                item.pickup(playerSelector(_worldFirst));
                _worldFirst.removeObject(newX, newY);

                itemOther.pickup(playerSelector(_worldSecond));
                _worldSecond.removeObject(newX, newY);
            }

            if (object is Evocation)
            {
                var evocation:Evocation = Evocation(object);
                var evocationOther:Evocation = Evocation(objectOther);

                playerSelector(_worldFirst).addEvocation(Evocation.EVOCATIONS.indexOf(Object(evocation).constructor));
                _worldFirst.removeObject(newX, newY);

                playerSelector(_worldSecond).addEvocation(Evocation.EVOCATIONS.indexOf(Object(evocationOther).constructor));
                _worldSecond.removeObject(newX, newY);
            }

            if (object is Rune)
            {
                var rune:Rune = Rune(object);
                var runeOther:Rune = Rune(objectOther);

                playerSelector(_worldFirst).addRune(Rune.RUNES.indexOf(Object(rune).constructor));
                _worldFirst.removeObject(newX, newY);

                playerSelector(_worldSecond).addRune(Rune.RUNES.indexOf(Object(runeOther).constructor));
                _worldSecond.removeObject(newX, newY);
            }

            if (object is Crystal)
            {
                var crystal:Crystal = Crystal(object);
                var crystalOther:Crystal = Crystal(objectOther);

                if (!crystal.charged)
                {

                    /// add points!

                    crystal.charge();
                    crystalOther.charge();
                }

                canMove = false;
            }

            if (object is Wall)
            {
                canMove = false;
            }

            if (canMove)
            {
                playerSelector(_worldFirst).changeLocation(newX * 32, newY * 32);
                playerSelector(_worldSecond).changeLocation(newX * 32, newY * 32);

                if (playerSelector(_worldFirst).activeEvocation != -1)
                {
                    playerSelector(_worldFirst).useEvocation(playerSelector(_worldFirst).activeEvocation)
                    playerSelector(_worldSecond).useEvocation(playerSelector(_worldSecond).activeEvocation)

                    playerSelector(_worldFirst).activeEvocation = -1;
                    playerSelector(_worldSecond).activeEvocation = -1;
                }
            }

            playerSelector(_worldFirst).chargeRunes();
            playerSelector(_worldSecond).chargeRunes();
        }

        private function other(world:World):World
        {
            return (world == _worldFirst) ? _worldSecond : _worldFirst;
        }

        private function player(world:World):Player
        {
            return (Prototype.current == FIRST) ? world.first : world.second;
        }

        private function playerOther(world:World):Player
        {
            return (Prototype.current == FIRST) ? world.second : world.first;
        }

        public function movePlayer(x:int, y:int):void
        {
            player(_worldFirst).x = x;
            player(_worldFirst).y = y;
            player(_worldSecond).x = x;
            player(_worldSecond).y = y;
        }

        public function pickFirstPlayer(seed:int):void
        {
            _worldFirst.pickFirstPlayer(seed);
            _worldSecond.pickFirstPlayer(seed);
        }

        public function pickSecondPlayer(seed:int):void
        {
            _worldFirst.pickSecondPlayer(seed);
            _worldSecond.pickSecondPlayer(seed);
        }
    }
}
