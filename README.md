Flexium API - Automated testing for Apache Flex and Selenium
=======

Flexium is a tool used for building automated [Selenium](http://seleniumhq.org/) tests.<br/>
Flexium is a work in progress, only having basic functionality (yet).

How does it work?
=======

Download the <b>FlexiumAPI.zip</b> file. The Flexium API consists out of 2 parts.<br/>

The first part is the Apache Flex-library, named <b>Flexium.swc</b>.<br/>
The only thing you need to do is to compile this swc into your Flex application. You can do this by adding <i>include-libraries Flexium.swc</i>
as a compiler option or adding a reference to the Flexium-class in your code.<br/>

The second part is a jar-file, named <b>FlexiumLink.jar</b>.<br/>
This file extends the FlexiumLink-class. FlexiumLink extends [flash-selenium](http://code.google.com/p/flash-selenium/) and
takes care off all the communication between your tests and the application.<br/>

Your Java test class looks like this:

    public class DemoAppTest {
        private final static String BASE_URL = "http://localhost/";
        private final static String PAGE = "flexiumDemo/DemoApp.html";
        private Selenium selenium;
        private FlexiumLink flexSelenium;
        private SeleniumServer _server;

        @Before
        public void setUp() throws Exception {
            _server = new SeleniumServer();

            _server.boot();
            _server.start();

            selenium = new DefaultSelenium("localhost", 4444, "*firefox", BASE_URL);
            selenium.start();
            selenium.open(PAGE);

            flexSelenium = new FlexiumLink(selenium, "DemoApp");
        }

        @After
        public void tearDown() throws Exception {
            selenium.stop();
            _server.stop();
        }

        @Test
        public void basicTests() throws Exception {
            flexSelenium.click("button");
        }
    }






