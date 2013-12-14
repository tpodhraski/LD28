package prototype.entities.runes
{
    public class RuneLogic
    {
        public var creates:Class;
        public var current:int;
        public var quality:int;
        public var target:int;

        public function RuneLogic()
        {
        }

        public function increase(additional:int):Boolean
        {
            var created:Boolean = false;

            current += additional * quality;
            if (current > target)
            {
                created = true;
                current = current - target;
            }

            return created;
        }
    }
}
