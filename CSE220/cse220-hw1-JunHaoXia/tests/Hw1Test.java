import org.junit.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;

public class Hw1Test {

  @Rule
  public Timeout timeout = new Timeout(30000, TimeUnit.MILLISECONDS);

  @Test
  public void verify_string_to_decimal_1() {
    Label args = asciiData(true, "D", "123");
    run("hw_main", 2, args);
    Assert.assertEquals(123, get(a0));
  }

  @Test
  public void verify_string_to_decimal_2() {
    Label args = asciiData(true, "D", "1");
    run("hw_main", 2, args);
    Assert.assertEquals(1, get(a0));
  }

  @Test
  public void verify_string_to_decimal_3() {
    Label args = asciiData(true, "D", "-123");
    run("hw_main", 2, args);
    Assert.assertEquals(-123, get(a0));
  }

  @Test
  public void verify_string_to_decimal_4() {
    Label args = asciiData(true, "D", "927482");
    run("hw_main", 2, args);
    Assert.assertEquals(927482, get(a0));
  }

  @Test
  public void verify_string_to_decimal_5() {
    Label args = asciiData(true, "D", "-927482");
    run("hw_main", 2, args);
    Assert.assertEquals(-927482, get(a0));
  }

  @Test
  public void verify_string_to_decimal_6() {
    Label args = asciiData(true, "D", "2147483647");
    run("hw_main", 2, args);
    Assert.assertEquals(2147483647, get(a0));
  }

  @Test
  public void verify_string_to_decimal_7() {
    Label args = asciiData(true, "D", "-2147483647");
    run("hw_main", 2, args);
    Assert.assertEquals(-2147483647, get(a0));
  }
  @Test
  public void verify_string_to_decimal_8() {
    Label args = asciiData(true, "D", "-2147483648");
    run("hw_main", 2, args);
    Assert.assertEquals(-2147483648, get(a0));
  }

  @Test
  public void verify_decode_itype_opcode_1() {
    Label args = asciiData(true, "O", "0x4CF8AB00");
    run("hw_main", 2, args);
    Assert.assertEquals(19, get(a0));
  }

  @Test
  public void verify_decode_itype_opcode_2() {
    Label args = asciiData(true, "O", "0xFAF8AB00");
    run("hw_main", 2, args);
    Assert.assertEquals(62, get(a0));
  }

  @Test
  public void verify_decode_itype_opcode_3() {
    Label args = asciiData(true, "O", "0xFFFF829");
    run("hw_main", 2, args);
    Assert.assertEquals(3, get(a0));
  }

  @Test
  public void verify_decode_itype_opcode_4() {
    Label args = asciiData(true, "O", "0xFFF829");
    run("hw_main", 2, args);
    Assert.assertEquals(0, get(a0));
  }

  @Test
  public void verify_decode_itype_rs_1() {
    Label args = asciiData(true, "S", "0xACE8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(7, get(a0));
  }

  @Test
  public void verify_decode_itype_rs_2() {
    Label args = asciiData(true, "S", "0xACD8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(6, get(a0));
  }

  @Test
  public void verify_decode_itype_rs_3() {
    Label args = asciiData(true, "S", "0xFFD8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(30, get(a0));
  }

  @Test
  public void verify_decode_itype_rs_4() {
    Label args = asciiData(true, "S", "0xFF18AB");
    run("hw_main", 2, args);
    Assert.assertEquals(7, get(a0));
  }

  @Test
  public void verify_decode_itype_rt_1() {
    Label args = asciiData(true, "T", "0xFCE8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(8, get(a0));
  }

  @Test
  public void verify_decode_itype_rt_2() {
    Label args = asciiData(true, "T", "0xFCE1AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(1, get(a0));
  }

  @Test
  public void verify_decode_itype_rt_3() {
    Label args = asciiData(true, "T", "0xFCD1AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(17, get(a0));
  }

  @Test
  public void verify_decode_itype_rt_4() {
    Label args = asciiData(true, "T", "0xCD1AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(17, get(a0));
  }


  @Test
  public void verify_decode_itype_imm_1() {
    Label args = asciiData(true, "I", "0xFCD12B92");
    run("hw_main", 2, args);
    Assert.assertEquals(11154, get(a0));
  }

  @Test
  public void verify_decode_itype_imm_2() {
    Label args = asciiData(true, "I", "0xFCDAAB92");
    run("hw_main", 2, args);
    Assert.assertEquals(-21614, get(a0));
  }

  @Test
  public void verify_decode_itype_imm_3() {
    Label args = asciiData(true, "I", "0xDA1FFF");
    run("hw_main", 2, args);
    Assert.assertEquals(8191, get(a0));
  }

  @Test
  public void verify_decode_itype_imm_4() {
    Label args = asciiData(true, "I", "0xAFCDFFFF");
    run("hw_main", 2, args);
    Assert.assertEquals(-1, get(a0));
  }

  @Test
  public void verify_decode_itype_inv_arg_1() {
    Label args = asciiData(true, "O", "0FCD7A1B");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_decode_itype_inv_arg_2() {
    Label args = asciiData(true, "I", "0xFCD7A1B890");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_decode_itype_inv_arg_3() {
    Label args = asciiData(true, "S", "0XFCD7A1");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_convert_hex_to_float_1() {
    Label args = asciiData(true, "F", "42864000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", 6, get(a0));
    Assert.assertEquals("Unexpected result", "1.00001100100000000000000", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_float_2() {
    Label args = asciiData(true, "F", "C2864000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", 6, get(a0));
    Assert.assertEquals("Unexpected result", "-1.00001100100000000000000", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_float_3() {
    Label args = asciiData(true, "F", "F4483B47");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", 105, get(a0));
    Assert.assertEquals("Unexpected result", "-1.10010000011101101000111", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_float_4() {
    Label args = asciiData(true, "F", "811234AC");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", -125, get(a0));
    Assert.assertEquals("Unexpected result", "-1.00100100011010010101100", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_Zero_1() {
    Label args = asciiData(true, "F", "00000000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "Zero\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Zero_2() {
    Label args = asciiData(true, "F", "80000000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "Zero\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Inf_1() {
    Label args = asciiData(true, "F", "FF800000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "-Inf\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Inf_2() {
    Label args = asciiData(true, "F", "7F800000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "+Inf\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Nan_1() {
    Label args = asciiData(true, "F", "7F800008");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "NaN\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Nan_2() {
    Label args = asciiData(true, "F", "FF800008");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "NaN\n", getString(get(a0)));
  }

  @Test
  public void verify_extra_args_err() {
    Label args = asciiData(true, "D", "123", "hello");
    run("hw_main", 3, args);
    Assert.assertEquals("Program requires exactly two arguments\n", getString(get(a0)));
  }

  @Test
  public void verify_less_args_err() {
    Label args = asciiData(true, "L");
    run("hw_main", 1, args);
    Assert.assertEquals("Program requires exactly two arguments\n", getString(get(a0)));
  }

  @Test
  public void verify_arg1_is_invalid() {
    Label args = asciiData(true, "Y", "123");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_arg1_has_length_gt1() {
    Label args = asciiData(true, "DX12", "123");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_arg1_has_length_gt2() {
    Label args = asciiData(true, "Opcode", "0x2A");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_arg1_has_length_zero() {
    Label args = asciiData(true, "", "123");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_secondarg_empty() {
    Label args = asciiData(true, "S", "");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_convert_hex_to_float_inv_arg_1() {
    Label args = asciiData(true, "F", "FF80000");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message as arg has less than 8 chars!", true);
    }
  }

  @Test
  public void verify_convert_hex_to_float_inv_arg_2() {
    Label args = asciiData(true, "F", "FF8000012");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message as arg has more than 8 chars!", true);
    }
  }

  @Test
  public void verify_convert_hex_to_float_inv_arg_3() {
    Label args = asciiData(true, "F", "FF80000a");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("One of the arguments is invalid\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message as arg has more than 8 chars!", true);
    }
  }

  @Test
  public void verify_loot_hand_1() {
    Label args = asciiData(true, "L", "M5M4P2P4P1M8");
    run("hw_main", 2, args);
    Assert.assertEquals(27, get(a0));
  }

  @Test
  public void verify_loot_hand_2() {
    Label args = asciiData(true, "L", "P3M4P2P4P1M8");
    run("hw_main", 2, args);
    Assert.assertEquals(20, get(a0));
  }

  @Test
  public void verify_loot_hand_3() {
    Label args = asciiData(true, "L", "P3P4P2P4P1P1");
    run("hw_main", 2, args);
    Assert.assertEquals(6, get(a0));
  }

  @Test
  public void verify_loot_hand_4() {
    Label args = asciiData(true, "L", "M3M4M6M5M4M8");
    run("hw_main", 2, args);
    Assert.assertEquals(48, get(a0));
  }

  @Test
  public void verify_loot_hand_5() {
    Label args = asciiData(true, "L", "1P2P3P4P9P6P");
    run("hw_main", 2, args);
    Assert.assertEquals("Loot Hand Invalid\n", getString(get(a0)));
  }

  @Test
  public void verify_loot_hand_6() {
    Label args = asciiData(true, "L", "M3P4M6M5M4P8");
    run("hw_main", 2, args);
    Assert.assertEquals("Loot Hand Invalid\n", getString(get(a0)));
  }
}
