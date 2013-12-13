package prototype
{
    public class Assets
    {
        [Embed(source="../../assets/Testing/Testing.png")]
        public static const Testing:Class;
        [Embed(source="../../assets/Testing/Testing.xml", mimeType = "application/octet-stream")]
        public static const TestingXML:Class;
    }
}
