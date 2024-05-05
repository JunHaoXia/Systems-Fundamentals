import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;

public class Hw0Test {

  @Test
  public void verify_test_msg() {
    run("hw0_main");
    Assert.assertEquals("This is a test program in mips\n", getString(get(a0)));
  }
}
