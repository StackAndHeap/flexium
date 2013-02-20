package be.stackandheap.flexiumLink;

import com.thoughtworks.selenium.FlashSelenium;

public class FlexiumLink extends FlashSelenium {
    /**
     * Interval for isReady calls, in milliseconds
     */
    public int interval = 500;
    /**
     * Maximum wait time in milliseconds
     */
    public int maxDelay = 20000;
    /**
     * Standard delay value in milliseconds.
     */
    public int delay = 0;
    /**
     * If set to true, every action will be delayed, using the integer delay.
     */
    public Boolean applyDelay = true;
    /**
     * If set to true, actions will be postponed until the application is ready.
     */
    public Boolean checkIfReady = true;

    /**
     * Creates a new flexiumLink class that communicates with the corresponding flashObjectId
     *
     * @param selenium Selenium
     * @param flashObjectId String
     */
    public FlexiumLink(com.thoughtworks.selenium.Selenium selenium, String flashObjectId) {
        super(selenium, flashObjectId);
    }

    /**
     * Simulates a Click event on the ActionScript object with objectId as id.
     * This function takes into account the delay() and isReady() methods.
     *
     * @param objectId String
     * @return Boolean
     * @throws Exception
     */
    public Boolean click(String objectId) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexClick", objectId, "");
            return checkResult(result);
        }
        return false;
    }

    /**
     * Clicks on an object inside of a popup.
     * This function takes into account the delay() and isReady() methods.
     *
     * @param objectId String
     * @return Boolean
     * @throws Exception
     */
    public Boolean clickInPopup(String objectId) throws Exception {
        delay();
        if(isReady()) {
            String result = call("clickInPopup", objectId);
            return checkResult(result);
        }
        return false;
    }

    /**
     * Simulates a double click on a Spark Datagrid with objectId as id, on the item with itemLabel as label and
     * in the column with headerLabel as headerLabel. This function takes into account the delay() and isReady() methods.
     *
     * @param objectId String
     * @param headerLabel String
     * @param itemLabel String
     * @return Boolean
     * @throws Exception
     */
    public Boolean dataGridDoubleClick(String objectId, String headerLabel, String itemLabel) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexDoubleClick", objectId, headerLabel + "||" + itemLabel);
            System.out.println(result);
            return checkResult(result);
        }
        return false;
    }

    /**
     * Selects an item in an ActionScript Object. This function takes into account the delay() and isReady() methods.
     *
     * @param objectId String
     * @param itemLabel String
     * @return Boolean
     * @throws Exception
     */
    public Boolean select(String objectId, String itemLabel) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexClick", objectId, itemLabel);
            return checkResult(result);
        }
        return false;
    }

    /**
     * Types the value into the text-property of the object. This function takes into account the delay() and isReady() methods.
     *
     * @param objectId String
     * @param value String
     * @return Boolean
     * @throws Exception
     */
    public Boolean type(String objectId, String value) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexType", objectId, value);
            return checkResult(result);
        }
        return false;
    }

    /**
     * Checks if the object is visible in the application. This function takes into account the delay() and isReady() methods.
     *
     * @param objectId String
     * @return Boolean
     * @throws Exception
     */
    public boolean isVisible(String objectId) throws Exception {
        delay();
        if(isReady()) {
            String result = call("isVisible", objectId);
            return checkResult(result);
        }
        return false;
    }

    /**
     * Wait's until an object is visible. Makes a call using the interval, takes the maxDelay into account.
     * @param objectId String
     * @return Boolean
     * @throws Exception
     */
    public boolean waitUntilVisible(String objectId) throws Exception {
        for (int i = 0; i < Math.round(maxDelay / interval); i++) {
            String result = call("isVisible", objectId);
            if(result.equals("true")) {
                return true;
            }
            try {
                Thread.sleep(interval);
            }catch (Exception ex) {
                return false;
            }
        }

        throw new Exception("Can't find element");
    }

    /**
     * Checks if the dataProvider of an object in the application contains items. This function takes into account the delay() and isReady() methods.
     *
     * @param objectId String
     * @return Boolean
     * @throws Exception
     */
    public Boolean hasItems(String objectId) throws Exception {
        delay();
        if(isReady()) {
            String result = call("hasItems", objectId);
            return checkResult(result);
        }
        return false;
    }

    /**
     * Checks if there's an alert shown in the application. This function takes into account the delay() and isReady() methods.
     *
     * @return Boolean
     * @throws Exception
     */
    public boolean alertVisible() throws Exception {
        delay();
        if(isReady()) {
            String result = call("alertVisible");
            return checkResult(result);
        }
        return false;
    }

    /**
     * Closes an Alert by clicking the label of the alerts buttons. This function takes into account the delay() and isReady() methods.
     *
     * @param label String
     * @return Boolean
     * @throws Exception
     */
    public Boolean closeAlertByLabel(String label) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexCloseAlert", label);
            return checkResult(result);
        }
        return false;
    }

    private static Boolean checkResult(String result) throws Exception{
        if(!result.equals("true") && !result.equals("false")) {
            throw new Exception(result);
        }
        return result.equals("true");
    }

    private void delay() {
        if(applyDelay && delay > 0) {
            try {
                Thread.sleep(delay);
            } catch (InterruptedException e) {
                System.out.println(e.toString());
            }
        }
    }

    /**
     * Checks if the application is ready to receive actions.
     *
     * @return Boolean
     * @throws Exception
     */
    public Boolean isReady() {
        if(!checkIfReady) {
            return true;
        }

        int countReady = 0;

        for (int i = 0; i < Math.round(maxDelay / interval); i++) {
            String result = call("getFlexCursorState");
            if(result.equals("0")) {
                countReady++;
                if(countReady == 2) {
                    return true;
                }
            } else {
                countReady = 0;
            }
            try {
                Thread.sleep(interval);
            }catch (Exception ex) {
                return false;
            }
        }

        return false;
    }


}
