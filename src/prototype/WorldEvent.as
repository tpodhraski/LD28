package prototype
{
    import starling.events.Event;

    public class WorldEvent extends Event
    {
        public static const CELL_SELECTED:String = "cellSelected";

        public var x:int;
        public var y:int;

        public var world:World;
        public var primary:Boolean;

        public function WorldEvent(type:String, x:int = 0, y:int = 0, world:World = null, primary:Boolean = true)
        {
            super(type);
            this.x = x;
            this.y = y;
            this.world = world;
            this.primary = primary;
        }
    }
}
