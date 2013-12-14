package prototype
{
    import Core.Random;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.geom.Point;
    import flash.utils.Dictionary;

    import main.Main;

    import prototype.entities.EvocationJump;

    import prototype.entities.Player;
    import prototype.objects.items.ItemGold;
    import prototype.objects.traps.TrapHole;

    import prototype.objects.Wall;
    import prototype.terrain.Terrain;

    import starling.display.DisplayObject;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    public class World extends Sprite
    {
        private var _level:Level;

        public var first:Player;
        public var second:Player;

        private var _firstPlayer:Array = [];
        private var _secondPlayer:Array = [];

        private var _objectToLocation:Dictionary;

        public function World(level:Level)
        {
            _level = level;

            _objectToLocation = new Dictionary();

            var objectMapping:Dictionary = new Dictionary();
            objectMapping[Wall.CODE] = Wall;
            objectMapping[TrapHole.CODE] = TrapHole;
            objectMapping[ItemGold.CODE] = ItemGold;
            objectMapping[EvocationJump.CODE] = EvocationJump;

            for (var j:int = 0; j < _level.height; j++)
            {
                for (var i:int = 0; i < _level.width; i++)
                {
                    var floor:uint = _level.floorAt(i, j);
                    if (floor == Terrain.TERRAIN_SIMPLE_GROUND) this.addChild(createTile("1", i * 32, j * 32));

                    var object:uint = _level.objectAt(i, j);
                    if (object in objectMapping)
                    {
                        var gameObject:DisplayObject = createObject(objectMapping[object], floor, i * 32, j * 32);

                        _objectToLocation[uniqueId(i, j)] = gameObject;
                        this.addChild(gameObject);
                    }

                    if (object == Player.SPAWN_FIRST) _firstPlayer.push(new Point(i, j));
                    if (object == Player.SPAWN_SECOND) _secondPlayer.push(new Point(i, j));
                }
            }

            this.addEventListener(TouchEvent.TOUCH, onTouch);
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

                var i:int = Math.floor(location.x / 32);
                var j:int = Math.floor(location.y / 32);

                stimulatePoint(i, j);
            }
        }

        public function stimulatePoint(x:Number, y:Number, primary:Boolean = true):void
        {
            if (x < 0 || x >= this.width || y < 0 || y >= this.height)
            {
                trace("Clicked outside the level!");
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
            first.x = point.x * 32;
            first.y = point.y * 32;
            this.addChild(first);
        }

        public function pickSecondPlayer(seed:int):void
        {
            var point:Point = _secondPlayer[seed % _secondPlayer.length];
            second = new Player(true);
            second.x = point.x * 32;
            second.y = point.y * 32;
            this.addChild(second);
        }

        private function createTile(id:String, x:Number, y:Number):Image
        {
            var texture:Texture = Main.testAtlas.getTexture(id);
            var image:Image = new Image(texture);
            image.x = x;
            image.y = y;
            return image;
        }

        private function createObject(classObject:Class, terrainId:uint, x:Number, y:Number):Image
        {
            var image:Image = new classObject(terrainId);
            image.x = x;
            image.y = y;
            return image;
        }

        public function objectAt(x:int, y:int):DisplayObject
        {
            return _objectToLocation[uniqueId(x, y)];
        }

        public function get level():Level
        {
            return _level;
        }

        public function removeObject(x:int, y:int):void
        {
            _objectToLocation[uniqueId(x, y)].removeFromParent();
            delete _objectToLocation[uniqueId(x, y)];
        }
    }
}
