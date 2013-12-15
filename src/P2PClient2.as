package
{
    import com.reyco1.multiuser.MultiUserSession;
    import com.reyco1.multiuser.data.UserObject;
    import com.reyco1.multiuser.debug.Logger;

    import starling.events.Event;

    import starling.events.EventDispatcher;

    public class P2PClient2 extends EventDispatcher
    {
        private const SERVER:String   = "rtmfp://p2p.rtmfp.net/";
        private const DEVKEY:String   = "b2a78189b9f91f2dc48fb0f1-90cfd56fee19";										// you can get a key from here : http://labs.adobe.com/technologies/cirrus/
        private const SERV_KEY:String = SERVER + DEVKEY;

        private var connection:MultiUserSession;
//        private var cursors:Object = {};
        private var myName:String;
        private var myColor:uint;
        private var _connected:Boolean;
        public static const CONNECTED:String = "connected";
        private var _code:String;

        public function P2PClient2(code:String)
        {
            _code = code;
            Logger.LEVEL = Logger.OWN;											// set Logger to only trace my traces
            initialize();
        }

        protected function initialize():void
        {
            connection = new MultiUserSession(SERV_KEY, _code); 		// create a new instance of MultiUserSession
            connection.onConnect 		= handleConnect;						// set the method to be executed when connected
            connection.onUserAdded 		= handleUserAdded;						// set the method to be executed once a user has connected
            connection.onUserRemoved 	= handleUserRemoved;					// set the method to be executed once a user has disconnected
            connection.onObjectRecieve 	= handleGetObject;						// set the method to be executed when we recieve data from a user

            myName  = "User_" + Math.round(Math.random()*100);					// my name
            myColor = Math.random()*0xFFFFFF;									// my color

            connection.connect(myName, {color:myColor});						// connect using my name and color variables

            log("waiting for connection");
        }

        protected function handleConnect(user:UserObject):void					// method should expect a UserObject
        {
            log("I'm connected: " + user.name + ", total: " + connection.userCount);
            //stage.addEventListener(MouseEvent.MOUSE_MOVE, sendMyData);

            _connected = true;
        }

        protected function handleUserAdded(user:UserObject):void				// method should expect a UserObject
        {
            log("User added: " + user.name + ", total users: " + connection.userCount);
//            cursors[user.id] = new CursorSprite(user.name, user.details.color);	// create a cursor for the new user that has just joined with his name and color
            //addChild( cursors[user.id] );

            //sendMyData();

            this.dispatchEventWith(CONNECTED);
        }

        protected function handleUserRemoved(user:UserObject):void				// method should expect a UserObject
        {
            log("User disconnected: " + user.name + ", total users: " + connection.userCount);
            //removeChild( cursors[user.id] );									// remove cursor for disconnected user
//            delete cursors[user.id];
        }

        protected function handleGetObject(peerID:String, data:Object):void
        {
            //cursors[peerID].update(data.x, data.y);								// update user cursor



            this.dispatchEventWith(Event.CHANGE, false, data);
        }

        public function send(message:String, dataObject:Object):void
        {
            if (!_connected) return;

            var date:Date = new Date();
            var timeMilliseconds:Number = date.time;

            var toSend:Object = {
                owner: myName,
                clientTime: timeMilliseconds,
                message: message,
                data: dataObject
            };

            connection.sendObject(toSend);
        }
    }
}