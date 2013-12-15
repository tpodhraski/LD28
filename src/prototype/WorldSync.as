package prototype
{
    import Core.Utility;

    import main.Build;

    import prototype.World;

    import prototype.World;
    import prototype.entities.enemies.Enemy;
    import prototype.ui.EvocationBar;

    import starling.events.Event;

    import main.Main;

    import prototype.entities.evocations.Evocation;
    import prototype.entities.evocations.EvocationJump;

    import prototype.entities.Player;
    import prototype.entities.runes.Rune;
    import prototype.objects.Crystal;
    import prototype.objects.items.Item;
    import prototype.objects.traps.Trap;
    import prototype.objects.Wall;

    import starling.display.DisplayObject;
    import starling.events.EventDispatcher;

    public class WorldSync extends EventDispatcher
    {
        public static const FIRST:int = 1;
        public static const SECOND:int = 2;
        private var _worldFirst:World;
        private var _worldSecond:World;

        private var _crystalPool:int;

        public function WorldSync(worldFirst:World, worldSecond:World)
        {
            _worldFirst = worldFirst;
            _worldSecond = worldSecond;

            _worldFirst.addEventListener(WorldEvent.CELL_SELECTED, onCellSelected);
            _worldSecond.addEventListener(WorldEvent.CELL_SELECTED, onCellSelected);

            if (Main.connection) Main.connection.addEventListener(Event.CHANGE, onNetworkChange);
        }

        private function onNetworkChange(event:Event):void
        {
            var data:Object = event.data.data;

            if (event.data.message == "cellSelected")
            {
                sendToServerOnCellSelected_DO(data.isFirst ? _worldFirst : _worldSecond, data.x, data.y);
                handleCellSelection(data.isFirst ? _worldFirst : _worldSecond, data.x, data.y);
            }
            if (event.data.message == "cellSelected_DO")
            {
                handleCellSelection(data.isFirst ? _worldFirst : _worldSecond, data.x, data.y);
            }

            if (event.data.message == "evocationChange")
            {
                Main.connection.send("evocationChange_DO", {first:data.first, index:data.index});
                setActiveEvocationInternal(data.first, data.index);
            }
            if (event.data.message == "evocationChange_DO")
            {
                setActiveEvocationInternal(data.first, data.index);
            }
            if (event.data.message == "evocationTransfer")
            {
                Main.connection.send("evocationTransfer_DO", {first:data.first, index:data.index});
                transferInternal(data.first, data.index);
            }
            if (event.data.message == "evocationTransfer_DO")
            {
                transferInternal(data.first, data.index);
            }
        }

        private function onCellSelected(event:WorldEvent):void
        {
//            if (event.primary) other(event.world).stimulatePoint(event.x, event.y, false);

            if (Main.isServer)
            {
                if (Main.connection) sendToServerOnCellSelected_DO(event.world, event.x, event.y);
                handleCellSelection(event.world, event.x, event.y);
            }
            else
            {
                sendToServerOnCellSelected(event.world, event.x, event.y);
            }

        }

        private function sendToServerOnCellSelected(world:World, x:Number, y:Number):void
        {
            var isFirst:Boolean = world == _worldFirst;
            Main.connection.send("cellSelected", {isFirst:isFirst, x:x, y:y});
        }
        private function sendToServerOnCellSelected_DO(world:World, x:Number, y:Number):void
        {
            var isFirst:Boolean = world == _worldFirst;

            Main.connection.send("cellSelected_DO", {isFirst:isFirst, x:x, y:y});
        }

        public function handleCellSelection(world_:World, x:int, y:int):void
        {

            function playerSelector(world:World):Player
            {
                return (world_ == _worldFirst) ? player(world) : playerOther(world);
            }
            function playerSelectorOther(world:World):Player
            {
                return (world_ == _worldFirst) ? playerOther(world) : player(world);
            }

            var canMove:Boolean = true;


            var eventPositionX:Number = x * Build.CELL_WIDTH;
            var eventPositionY:Number = y * Build.CELL_HEIGHT;

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

            var newX:int = Math.floor(playerSelector(_worldFirst).x / Build.CELL_WIDTH) + directionX;
            var newY:int = Math.floor(playerSelector(_worldFirst).y / Build.CELL_HEIGHT) + directionY;



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

                    playerSelector(_worldFirst).souls += 3;
                    playerSelector(_worldSecond).souls += 3;

                    crystal.charge();
                    crystalOther.charge();



                    var newMin:int = Math.min(playerSelector(_worldFirst).souls,
                    playerSelectorOther(_worldFirst).souls)

                    if (newMin > _crystalPool)
                    {
                        var diff:int = newMin - _crystalPool;

                        this.crystalPool = newMin;

                        playerSelector(_worldFirst).chargeRunes(diff);
                        playerSelector(_worldSecond).chargeRunes(diff);

                        log("Charged for: " + diff.toString());

                    }

                }

                canMove = false;
            }

            if (object is Enemy)
            {
                var enemy:Enemy = Enemy(object);
                var enemyOther:Enemy = Enemy(objectOther);

                enemy.health -= playerSelector(_worldFirst).damage;
                enemyOther.health -= playerSelector(_worldSecond).damage;
                log("you hit the bastard ",playerSelector(_worldFirst).damage );

                if (enemy.health <= 0)
                {

                    _worldFirst.removeEnemy(enemy);
                    _worldSecond.removeEnemy(enemyOther);

                }

                canMove = false;
            }

            if (object is Wall)
            {
                canMove = false;
            }

            if (canMove)
            {
                playerSelector(_worldFirst).changeLocation(newX * Build.CELL_WIDTH, newY * Build.CELL_HEIGHT);
                _worldFirst.updateChild(playerSelector(_worldFirst));

                playerSelector(_worldSecond).changeLocation(newX * Build.CELL_WIDTH, newY * Build.CELL_HEIGHT);
                _worldSecond.updateChild(playerSelector(_worldSecond));

                _worldFirst.sortObjects();
                _worldSecond.sortObjects();

                if (playerSelector(_worldFirst).activeEvocation != -1)
                {
                    playerSelector(_worldFirst).useEvocation(playerSelector(_worldFirst).activeEvocation);
                    playerSelector(_worldSecond).useEvocation(playerSelector(_worldSecond).activeEvocation);

                    playerSelector(_worldFirst).activeEvocation = -1;
                    playerSelector(_worldSecond).activeEvocation = -1;
                }

            }

            runAI((world_ == _worldFirst));


        }

        private function runAI(isFirst:Boolean):void
        {
            function playerSelector(world:World):Player
            {
                return isFirst ? player(world) : playerOther(world);
            }
            function playerSelectorOther(world:World):Player
            {
                return isFirst? playerOther(world) : player(world);
            }

            var enemies:Array;
            var enemiesOther:Array;
            if (isFirst)
            {
                enemies = _worldFirst.getEnemies(-_worldFirst.x / Build.CELL_WIDTH - 1, -_worldFirst.y / Build.CELL_HEIGHT - 1, 17, 13);
                enemiesOther = _worldSecond.getEnemies(-_worldFirst.x / Build.CELL_WIDTH - 1, -_worldFirst.y / Build.CELL_HEIGHT - 1, 17, 13);
            }
            else
            {
                enemies = _worldFirst.getEnemies(-_worldSecond.x / Build.CELL_WIDTH - 1, -_worldSecond.y / Build.CELL_HEIGHT - 1, 17, 13);
                enemiesOther = _worldSecond.getEnemies(-_worldSecond.x / Build.CELL_WIDTH - 1, -_worldSecond.y / Build.CELL_HEIGHT - 1, 17, 13);

            }

//            var enemiesOther:Array = _worldFirst.;

            /// find all enemies that are visible;


            function doAI(enemy:Enemy,world:World):void
            {
                var directionX:Number = playerSelector(world).x - enemy.x;
                var directionY:Number = playerSelector(world).y - enemy.y;
                var directionX2:Number = directionX;
                var directionY2:Number = directionY;

                if (Math.abs(directionX) > Math.abs(directionY))
                {
                    directionX = Utility.sign(directionX);
                    directionY = 0;

                    directionX2 = 0;
                    directionY2 = Utility.sign(directionY2);

                }
                else
                {
                    directionX = 0;
                    directionY = Utility.sign(directionY);

                    directionX2 = Utility.sign(directionX2);
                    directionY2 = 0;
                }

                var newX:int = Math.floor( enemy.x / Build.CELL_WIDTH) + directionX;
                var newY:int = Math.floor( enemy.y / Build.CELL_HEIGHT) + directionY;



                var newX2:int = Math.floor( enemy.x / Build.CELL_WIDTH) + directionX2;
                var newY2:int = Math.floor( enemy.y / Build.CELL_HEIGHT) + directionY2;

                function collision(newX, newY):Boolean
                {
                    return world.objectAt(newX, newY) != null && !(world.objectAt(newX, newY) is Trap);

                }

                if (collision(newX, newY))
                {
                    newX = newX2;
                    newY = newY2;
                }

                var playerx:int = Math.floor(playerSelector(world).x / Build.CELL_WIDTH);
                var playery:int = Math.floor(playerSelector(world).y / Build.CELL_HEIGHT);

                if (playerx == newX && playery == newY)
                {
                    log("enemy attacks you! ", enemy.damage);
                    playerSelector(world).health -= enemy.damage;
                }
                //else if (trap)
                else if (!collision(newX, newY))
                {
                    //// ...


                    enemy.changeLocation(newX * Build.CELL_WIDTH, newY * Build.CELL_HEIGHT);
                    world.updateChild(enemy);
                }




            }

            for (var i:int = 0; i < enemies.length; i++)
            {
                var enemy:Enemy = enemies[i];
                var enemyOther:Enemy = enemiesOther[i];

                doAI(enemy, _worldFirst);
                doAI(enemyOther, _worldSecond);
            }


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

        public function setActiveEvocation(_first:Boolean, selectedIndex:int):void
        {
            if (Main.isServer)
            {
                if (Main.connection) Main.connection.send("evocationChange_DO", {first:_first, index:selectedIndex});
                setActiveEvocationInternal(_first, selectedIndex);
            }
            else
            {
                Main.connection.send("evocationChange", {first:_first, index:selectedIndex});
            }
        }

        private function setActiveEvocationInternal(_first:Boolean, selectedIndex:int):void
        {
            function selector(world:World):Player
            {
                return _first ? player(world) : playerOther(world);
            }

            selector(_worldFirst).activeEvocation = selectedIndex;
            selector(_worldSecond).activeEvocation = selectedIndex;
        }

        public function get crystalPool():int
        {
            return _crystalPool;
        }

        public function set crystalPool(value:int):void
        {
            _crystalPool = value;
            this.dispatchEventWith(Event.CHANGE);
        }

        public function transfer(_first:Boolean, activeEvocation:int):void
        {
            if (Main.isServer)
            {
                if (Main.connection) Main.connection.send("evocationTransfer_DO", {first:_first, index:activeEvocation});
                transferInternal(_first, activeEvocation);
            }
            else
            {
                Main.connection.send("evocationTransfer", {first:_first, index:activeEvocation});
            }

        }

        public function transferInternal(_first:Boolean, activeEvocation:int):void
        {
            function selector(world:World):Player
            {
                return _first ? player(world) : playerOther(world);
            }
            function selectorOther(world:World):Player
            {
                return _first ? playerOther(world) : player(world);
            }

            selector(_worldFirst).gold -= EvocationBar.TRANSFER_PRICE;
            selector(_worldSecond).gold -= EvocationBar.TRANSFER_PRICE;


            selector(_worldFirst).useEvocation(activeEvocation);
            selector(_worldSecond).useEvocation(activeEvocation);

            selectorOther(_worldFirst).addEvocation(activeEvocation);
            selectorOther(_worldSecond).addEvocation(activeEvocation);

            selector(_worldFirst).activeEvocation = -1;
            selector(_worldSecond).activeEvocation = -1;

        }
    }
}
