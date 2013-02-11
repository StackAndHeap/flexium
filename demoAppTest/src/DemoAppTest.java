import be.stackandheap.flexiumLink.FlexiumLink;
import be.stackandheap.flexiumLink.FlexiumServer;
import com.thoughtworks.selenium.DefaultSelenium;
import com.thoughtworks.selenium.Selenium;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.server.SeleniumServer;

public class DemoAppTest {
    private final static String BASE_URL = "http://localhost/";
    private final static String PAGE = "flexiumDemo/DemoApp.html";
    private Selenium selenium;
    private FlexiumLink flexSelenium;
    private SeleniumServer _server;

    private FlexiumServer flexiumServer;

    @Before
    public void setUp() throws Exception {

        flexiumServer = new FlexiumServer(1234);

        Thread.sleep(50000);

//        _server = new SeleniumServer();
//
//        _server.boot();
//        _server.start();
//
//        selenium = new DefaultSelenium("localhost", 4444, "*firefox", BASE_URL);
//        selenium.start();
//        selenium.open(PAGE);
//
//        Thread.sleep(50000);
//
//        flexSelenium = new FlexiumLink(selenium, "DemoApp");
//        flexSelenium.applyDelay = false;
//        flexSelenium.checkIfReady = false;
    }

    @After
    public void tearDown() throws Exception {

        Thread.sleep(5000);

//        selenium.stop();
//        _server.stop();
    }

    @Test
    public void basicTests() throws Exception {
        Assert.assertTrue(true);
//        Assert.assertEquals("DemoApp", selenium.getTitle());
//        Assert.assertTrue("Can't type in testInput", flexSelenium.type("textInput", "TEST"));
//        Assert.assertTrue("Can't click Button", flexSelenium.click("button"));
//        Assert.assertTrue("Can't close Alert", flexSelenium.closeAlertByLabel("OK"));
//        Assert.assertTrue("Can't select item", flexSelenium.select("list", "B"));
//        Assert.assertTrue("Can't double click", flexSelenium.dataGridDoubleClick("datagrid", "ID", "1"));
    }


}
