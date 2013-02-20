import be.stackandheap.flexiumLink.FlexiumLink;
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

    @Before
    public void setUp() throws Exception {
        _server = new SeleniumServer();

        _server.boot();
        _server.start();

        selenium = new DefaultSelenium("localhost", 4444, "*firefox", BASE_URL);
        selenium.start();
        selenium.open(PAGE);

        Thread.sleep(5000);

        flexSelenium = new FlexiumLink(selenium, "DemoApp");
    }

    @After
    public void tearDown() throws Exception {
        Thread.sleep(5000);

        selenium.stop();
        _server.stop();
    }

    @Test
    public void basicTests() throws Exception {
        flexSelenium.type("textInput", "TEST");
        flexSelenium.click("button");
//        flexSelenium.clickInPopup("closeBtn");
//        flexSelenium.closeAlertByLabel("OK");
//        Assert.assertTrue(flexSelenium.isVisible("button"));
//        Assert.assertFalse(flexSelenium.isVisible("invisibleButton"));
//        flexSelenium.select("list", "B");
//        Assert.assertTrue(flexSelenium.hasItems("datagrid"));
//        flexSelenium.dataGridDoubleClick("datagrid", "ID", "1");
//        Assert.assertTrue(flexSelenium.alertVisible());
    }


}
