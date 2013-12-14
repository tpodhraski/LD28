package prototype
{
    public class Xorshift
    {
        private var x:uint = 123456789;
        private var y:uint = 362436069;
        private var z:uint = 521288629;
        private var w:uint = 88675123;

        private var last:uint = 2308;

        public function Xorshift()
        {
            randomize();
        }

        public function randomize(times:int = 1):void
        {
            for (var i:int = 0; i < times; i++) xor128();
        }

        private function xor128():void
        {
            last = x ^ (x << 11);
            x = y; y = z; z = w;
            last = w = w ^ (w >> 19) ^ (last ^ (last >> 8));
        }

        public function readLast():uint
        {
            return last;
        }

        public function random():uint
        {
            xor128();
            return readLast();
        }

        public function randomPercent():Number
        {
            xor128();
            return readLastPercent();
        }

        public function readLastPercent():Number
        {
            return (last % 10000) / 10000.0;
        }
    }
}
