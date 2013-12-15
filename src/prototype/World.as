package prototype
{
    import Core.Utility;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    import main.Build;
    import main.Main;

    import prototype.entities.Player;
    import prototype.entities.enemies.Enemy;
    import prototype.entities.enemies.EnemyEater;
    import prototype.entities.evocations.Evocation;
    import prototype.entities.runes.Rune;
    import prototype.objects.Crystal;
    import prototype.objects.Wall;
    import prototype.objects.items.ItemGold;
    import prototype.objects.items.ItemHeart;
    import prototype.objects.traps.TrapHole;
    import prototype.terrain.Terrain;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.extensions.QuadtreeSprite;
    import starling.textures.Texture;

    public class World extends QuadtreeSprite
    {
        private var _level:Level;

        public var first:Player;
        public var second:Player;

        private var _firstPlayer:Array = [];
        private var _secondPlayer:Array = [];

        private var _objectToLocation:Dictionary;
        private var _random:Xorshift;
        private var enemies:Array;

        public function World(level:Level, seed:int)
        {
            super(new Rectangle(0, 0, level.width * Build.CELL_WIDTH, level.height * Build.CELL_HEIGHT), true);

            _level = level;
            _random = new Xorshift();
            _random.randomize(seed % 1000);

            _objectToLocation = new Dictionary();

            enemies =[];

            var objectMapping:Dictionary = new Dictionary();
            objectMapping[Wall.CODE] = Wall;
            objectMapping[TrapHole.CODE] = TrapHole;
            objectMapping[ItemGold.CODE] = ItemGold;
            objectMapping[ItemHeart.CODE] = ItemHeart;
            objectMapping[Crystal.CODE] = Crystal;
            objectMapping[EnemyEater.CODE] = EnemyEater;
//            objectMapping[EvocationJump.CODE] = EvocationJump;

            for (var j:int = 0; j < _level.height; j++)
            {
                for (var i:int = 0; i < _level.width; i++)
                {
                    var floor:uint = _level.floorAt(i, j);
                    if (floor == Terrain.TERRAIN_SIMPLE_GROUND) this.addChild(createTile("Area1Floor", i * Build.CELL_WIDTH, j * Build.CELL_HEIGHT));
                }
            }

            for (var j:int = 0; j < _level.height; j++)
            {
                for (var i:int = 0; i < _level.width; i++)
                {
                    var floor:uint = _level.floorAt(i, j);

                    var object:uint = _level.objectAt(i, j);
                    if (object in objectMapping)
                    {
                        var dp:DisplayObject = createObject(objectMapping[object], floor, i, j);

                    }

                    if (object == Player.SPAWN_FIRST) _firstPlayer.push(new Point(i, j));
                    if (object == Player.SPAWN_SECOND) _secondPlayer.push(new Point(i, j));

                    if (object == Evocation.CODE)
                    {
                        createObject(Evocation.EVOCATIONS[_random.random() % Evocation.EVOCATIONS.length], floor, i, j);
                    }
                    if (object == Rune.CODE)
                    {
                        createObject(Rune.RUNES[_random.random() % Rune.RUNES.length], floor, i, j);
                    }
                }
            }

            this.addEventListener(TouchEvent.TOUCH, onTouch);

            sortObjects();
        }

        public function sortObjects():void
        {
            this.sortQuad(function(a:DisplayObject, b:DisplayObject):Number
            {
                var aValue:Number = a.y;
                var bValue:Number = b.y;

                if (a is FloorTile) aValue -= 100000;
                if (b is FloorTile) bValue -= 100000;


                return aValue - bValue;
            });
        }

        private function uniqueId(i:int, j:int):String
        {
            return i.toString() + "x" + j.toString();
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this);

            if (touch && touch.phase == TouchPhase.BEGAN)
            {
                var location:Point = touch.getLocation(this);

                var i:int = Math.floor(location.x / Build.CELL_WIDTH);
                var j:int = Math.floor(location.y / Build.CELL_HEIGHT);

                stimulatePoint(i, j);
            }
        }

        public function stimulatePoint(x:Number, y:Number, primary:Boolean = true):void
        {
            if (x < 0 || x >= this.width || y < 0 || y >= this.height)
            {
                log("Clicked outside the level!");
            }
            else
            {
                var event:WorldEvent = new WorldEvent(WorldEvent.CELL_SELECTED, x, y, this, primary);
                this.dispatchEvent(event);
            }
        }

        public function pickFirstPlayer(seed:int):void
        {
            var point:Point = _firstPlayer[seed % _firstPlayer.length];
            first = new Player();
            first.x = point.x * Build.CELL_WIDTH;
            first.y = point.y * Build.CELL_HEIGHT;
            this.addChild(first);
            sortObjects();
        }

        public function pickSecondPlayer(seed:int):void
        {
            var point:Point = _secondPlayer[seed % _secondPlayer.length];
            second = new Player(true);
            second.x = point.x * Build.CELL_WIDTH;
            second.y = point.y * Build.CELL_HEIGHT;
            this.addChild(second);
            sortObjects();
        }

        private function createTile(id:String, x:Number, y:Number):Image
        {
            var texture:Texture = Main.testAtlas.getTexture(id);
            var image:Image = new FloorTile(texture);
            image.x = x;
            image.y = y;
            return image;
        }

        private function createObject(classObject:Class, terrainId:uint, x:Number, y:Number):DisplayObject
        {
            var image:DisplayObject = new classObject(terrainId);
            image.x = x * Build.CELL_WIDTH;
            image.y = y * Build.CELL_HEIGHT;

            if (image is Enemy) enemies.push(image);
            else                _objectToLocation[uniqueId(x, y)] = image;

            this.addChild(image);
            return image;

        }


        public function objectAt(x:int, y:int):DisplayObject
        {
            if (_objectToLocation[uniqueId(x, y)]) return _objectToLocation[uniqueId(x, y)];


            for each (var enemy:Enemy in enemies)
            {
                var nx:int = Math.floor(enemy.x / Build.CELL_WIDTH);
                var ny:int = Math.floor(enemy.y / Build.CELL_HEIGHT);
                if (nx == x &&  ny == y)
                {
                    return enemy;

                }
            }

            return null;
        }

        public function get level():Level
        {
            return _level;
        }

        public function removeObject(x:int, y:int):void
        {
            this.removeChild(_objectToLocation[uniqueId(x, y)]);
            delete _objectToLocation[uniqueId(x, y)];
        }

        public function get random():Xorshift
        {
            return _random;
        }

        public function getEnemies(x:int, y:int, w:int, h:int):Array
        {
            var rectangle:Rectangle = new Rectangle(x * 32, y * 32, w * 32, h * 32);

            var toReturn:Array = [];

            for each (var enemy:Enemy in enemies)
            {
                if (rectangle.contains(enemy.x, enemy.y))
                {
                    toReturn.push(enemy);

                }
            }

            return toReturn;




        }

        public function removeEnemy(enemy:Enemy):void
        {
            Utility.removeFromArray(enemies, enemy);
            this.removeChild(enemy);

        }
    }
}
