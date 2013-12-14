package prototype.entities
{
    import starling.events.Event;

    public class PlayerEvent extends Event
    {
        public static const CHANGE:String = "change";
        public static const CHANGE_LOCATION:String = "changeLocation";

        public function PlayerEvent(type:String = CHANGE)
        {
            super(type);
        }
    }
}
