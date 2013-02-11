package be.stackandheap.flexiumLink;

import com.thoughtworks.selenium.FlashSelenium;

public class FlexiumLink extends FlashSelenium {
    public int interval = 500;
    public int maxDelay = 20000;
    public int delay = 0;
    public Boolean applyDelay = true;
    public Boolean checkIfReady = true;

    public FlexiumLink(com.thoughtworks.selenium.Selenium selenium, String flashObjectId) {
        super(selenium, flashObjectId);
    }

    public Boolean click(String objectId) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexClick", objectId, "");
            return checkResult(result);
        }
        return false;
    }

    public Boolean dataGridDoubleClick(String objectId, String headerLabel, String itemLabel) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexDoubleClick", objectId, headerLabel + "||" + itemLabel);
            System.out.println(result);
            return checkResult(result);
        }
        return false;
    }

    public Boolean select(String objectId, String itemLabel) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexClick", objectId, itemLabel);
            return checkResult(result);
        }
        return false;
    }

    public Boolean type(String objectId, String value) throws Exception {
        delay();
        if(isReady()) {
            String result = call("doFlexType", objectId, value);
            return checkResult(result);
        }
        return false;
    }

    public boolean isVisible(String objectId) throws Exception {
        delay();
        if(isReady()) {
            String result = call("isVisible", objectId);
            return checkResult(result);
        }
        return false;
    }

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
