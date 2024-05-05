import org.junit.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;

public class Hw2Test {

  private int reg_sp = 0;
  private int reg_s0 = 0;
  private int reg_s1 = 0;
  private int reg_s2 = 0;
  private int reg_s3 = 0;
  private int reg_s4 = 0;
  private int reg_s5 = 0;
  private int reg_s6 = 0;
  private int reg_s7 = 0;

  @Before
  public void preTest() {
    this.reg_s0 = get(s0);
    this.reg_s1 = get(s1);
    this.reg_s2 = get(s2);
    this.reg_s3 = get(s3);
    this.reg_s4 = get(s4);
    this.reg_s5 = get(s5);
    this.reg_s6 = get(s6);
    this.reg_s7 = get(s7);
    this.reg_sp = get(sp);
  }

  @After
  public void postTest() {
    Assert.assertEquals("Register convention violated $s0", this.reg_s0, get(s0));
    Assert.assertEquals("Register convention violated $s1", this.reg_s1, get(s1));
    Assert.assertEquals("Register convention violated $s2", this.reg_s2, get(s2));
    Assert.assertEquals("Register convention violated $s3", this.reg_s3, get(s3));
    Assert.assertEquals("Register convention violated $s4", this.reg_s4, get(s4));
    Assert.assertEquals("Register convention violated $s5", this.reg_s5, get(s5));
    Assert.assertEquals("Register convention violated $s6", this.reg_s6, get(s6));
    Assert.assertEquals("Register convention violated $s7", this.reg_s7, get(s7));
    Assert.assertEquals("Register convention violated $sp", this.reg_sp, get(sp));
  }

  @Rule
  public Timeout timeout = new Timeout(30000, TimeUnit.MILLISECONDS);

  @Test
  public void verify_encrypt_block_1() {
    Label block = asciiData(true, "abra");
    Label key = asciiData(true, "abrc");
    run("encrypt_block", block, key);
    Assert.assertEquals(2, get(v0));
  }

  @Test
  public void verify_encrypt_block_2() {
    Label block = asciiData(false, "left");
    Label key = asciiData(false, "@#2*");
    run("encrypt_block", block, key);
    Assert.assertEquals(742806622, get(v0));
  }

  @Test
  public void verify_encrypt_block_3() {
    Label block = asciiData(false, "mips");
    Label key = asciiData(false, "spim");
    run("encrypt_block", block, key);
    Assert.assertEquals(504961310, get(v0));
  }

  @Test
  public void verify_encrypt_block_4() {
    Label block = asciiData(false, "tonic");
    Label key = asciiData(false, "s0cK");
    run("encrypt_block", block, key);
    Assert.assertEquals(123669794, get(v0));
  }

  @Test
  public void verify_encrypt_block_5() {
    Label block = asciiData(false, "unix");
    Label key = asciiData(false, "s0cKet");
    run("encrypt_block", block, key);
    Assert.assertEquals(106826291, get(v0));
  }

  @Test
  public void verify_encrypt_block_6() {
    Label block = asciiData(false, "unix");
    Label key = asciiData(false, "unitt");
    run("encrypt_block", block, key);
    Assert.assertEquals(12, get(v0));
  }

  @Test
  public void verify_add_block_1() {
    Label ciphertext = emptyBytes(4);
    run("add_block", ciphertext, 0, 10393);
    byte[] actual = getBytes(ciphertext, 0, 4);
    byte[] expected = {-103,40,0,0};
    for(int i=0; i< expected.length ; i++) {
      Assert.assertEquals(expected[i], actual[i]);
    }
  }

  @Test
  public void verify_add_block_2() {
    Label ciphertext = emptyBytes(4);
    run("add_block", ciphertext, 0, 29811);
    byte[] actual = getBytes(ciphertext, 0, 4);
    byte[] expected = {115,116,0,0};
    for(int i=0; i< expected.length ; i++) {
      Assert.assertEquals(expected[i], actual[i]);
    }
  }

  @Test
  public void verify_add_block_3() {
    Label ciphertext = emptyBytes(4);
    run("add_block", ciphertext, 0, 638292);
    byte[] actual = getBytes(ciphertext, 0, 4);
    byte[] expected = {84,-67,9,0};
    for(int i=0; i< expected.length ; i++) {
      Assert.assertEquals(expected[i], actual[i]);
    }
  }

  @Test
  public void verify_add_block_4() {
    Label text = emptyBytes(4);
    run("add_block", text, 0, 12);
    byte[] actual = getBytes(text, 0, 4);
    byte[] expected = {12,0,0,0};
    for(int i=0; i< expected.length ; i++) {
      Assert.assertEquals(expected[i], actual[i]);
    }
  }

  @Test
  public void verify_add_block_5() {
    Label text = emptyBytes(8);
    run("add_block", text, 1, 123669794);
    byte[] actual = getBytes(text, 4, 4);
    byte[] expected = {34,13,95,7};
    for(int i=0; i< expected.length ; i++) {
      Assert.assertEquals(expected[i], actual[i]);
    }
  }

  @Test
  public void verify_add_block_6() {
    Label ciphertext = emptyBytes(40);
    run("add_block", ciphertext, 9, 29811);
    byte[] actual = getBytes(ciphertext, 36, 4);
    byte[] expected = {115,116,0,0};
    for(int i=0; i< expected.length ; i++) {
      Assert.assertEquals(expected[i], actual[i]);
    }
  }


  @Test
  public void verify_gen_key_1() {
    Label key = emptyBytes(4);
    run("gen_key", key, 0);
    byte[] actual = getBytes(key, 0, 4);
    for(int i=0; i< actual.length ; i++) {
      Assert.assertTrue(actual[i] < 128 && actual[i] >= -128);
    }
  }

  @Test
  public void verify_gen_key_2() {
    Label key = asciiData("aaaaaaaa");
    run("gen_key", key, 1);
    byte[] key1 = getBytes(key, 0, 4);
    byte[] key2 = getBytes(key, 4, 4);
    for(int i=0; i< key1.length ; i++) {
      Assert.assertEquals(97, key1[i]);
    }
    for(int i=0; i< key2.length ; i++) {
      Assert.assertTrue(key2[i] < 128 && key2[i] >= -128);
    }
  }

  @Test
  public void verify_gen_key_3() {
    Label key = asciiData("kkkkkkkkkkkkkkkkzzzz");
    run("gen_key", key, 4);
    byte[] key1 = getBytes(key, 0, 16);
    byte[] key2 = getBytes(key, 16, 4);
    for(int i=0; i< key1.length ; i++) {
      Assert.assertEquals(107, key1[i]);
    }
    for(int i=0; i< key2.length ; i++) {
      Assert.assertTrue(key2[i] < 128 && key2[i] >= -128);
    }
  }

  @Test
  public void verify_encrypt_1() {
    Label plain = asciiData(false, "SeaWolf");
    Label buf = emptyBytes(1);
    Label key = emptyBytes(8);
    Label cipher = emptyBytes(8);
    run("encrypt", plain, key, cipher, "SeaWolf".length());
    byte[] plainBytes = getBytes(plain, 0, 8);
    byte[] keyBytes = getBytes(key, 0, 8);
    byte[] cipherBytes = getBytes(cipher, 0, 8);
    for(int i=1; i <= 2; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_encrypt_2() {
    Label plain = asciiData(false, "I love MIPS");
    Label buf = emptyBytes(1);
    Label key = emptyBytes(12);
    Label cipher = emptyBytes(12);
    run("encrypt", plain, key, cipher, "I love MIPS".length());
    byte[] plainBytes = getBytes(plain, 0, 12);
    byte[] keyBytes = getBytes(key, 0, 12);
    byte[] cipherBytes = getBytes(cipher, 0, 12);
    for(int i=1; i <= 3; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_encrypt_3() {
    Label plain = asciiData(false, "CSE-2201");
    Label key = emptyBytes(8);
    Label cipher = emptyBytes(8);
    run("encrypt", plain, key, cipher, "CSE-2201".length());
    byte[] plainBytes = getBytes(plain, 0, 8);
    byte[] keyBytes = getBytes(key, 0, 8);
    byte[] cipherBytes = getBytes(cipher, 0, 8);
    for(int i=1; i <= 2; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_encrypt_4() {
    Label plain = asciiData(false, "Confidential Message. Do not share.");
    Label buf = emptyBytes(1);
    Label key = emptyBytes(36);
    Label cipher = emptyBytes(36);
    run("encrypt", plain, key, cipher, "Confidential Message. Do not share.".length());
    byte[] plainBytes = getBytes(plain, 0, 36);
    byte[] keyBytes = getBytes(key, 0, 36);
    byte[] cipherBytes = getBytes(cipher, 0, 36);
    for(int i=1; i <= 9; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_encrypt_5() {
    Label plain = asciiData(false, "This message was encrypted using block cipher!");
    Label buf = emptyBytes(2);
    Label key = emptyBytes(48);
    Label cipher = emptyBytes(48);
    run("encrypt", plain, key, cipher, "This message was encrypted using block cipher!".length());
    byte[] plainBytes = getBytes(plain, 0, 48);
    byte[] keyBytes = getBytes(key, 0, 48);
    byte[] cipherBytes = getBytes(cipher, 0, 48);
    for(int i=1; i <= 12; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_encrypt_6() {
    Label plain = asciiData(false, "You transfered $100,000 to Jhontu Rhodes");
    Label key = emptyBytes(40);
    Label cipher = emptyBytes(40);
    run("encrypt", plain, key, cipher, 40);
    byte[] plainBytes = getBytes(plain, 0, 40);
    byte[] keyBytes = getBytes(key, 0, 40);
    byte[] cipherBytes = getBytes(cipher, 0, 40);
    for(int i=1; i <= 10; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_encrypt_7() {
    Label plain = asciiData(false, "Social Security Number : XX-XXX-XXXX.");
    Label buf = emptyBytes(3);
    Label key = emptyBytes(40);
    Label cipher = emptyBytes(40);
    run("encrypt", plain, key, cipher, 40);
    byte[] plainBytes = getBytes(plain, 0, 40);
    byte[] keyBytes = getBytes(key, 0, 40);
    byte[] cipherBytes = getBytes(cipher, 0, 40);
    for(int i=1; i <= 10; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_encrypt_8() {
    Label plain = asciiData(false, "password : 123456789.@?");
    Label buf = emptyBytes(1);
    Label key = emptyBytes(24);
    Label cipher = emptyBytes(24);
    run("encrypt", plain, key, cipher, 24);
    byte[] plainBytes = getBytes(plain, 0, 24);
    byte[] keyBytes = getBytes(key, 0, 24);
    byte[] cipherBytes = getBytes(cipher, 0, 24);
    for(int i=1; i <= 6; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " encryption does not match expected result!", ((plainBytes[k])^(keyBytes[k])), cipherBytes[j]);
      }
    }
  }

  @Test
  public void verify_decrypt_block_1() {
    Label cipherblock = asciiData(true, "us1u");
    Label key = asciiData(true, "u5su");
    run("decrypt_block", cipherblock, key);
    Assert.assertEquals(1024, get(v0));
  }

  @Test
  public void verify_decrypt_block_3() {
    Label cipherblock = asciiData(true, "k)jp");
    Label key = asciiData(true, "pj!k");
    run("decrypt_block", cipherblock, key);
    Assert.assertEquals(524288, get(v0));
  }

  @Test
  public void verify_decrypt_block_4() {
    Label cipherblock = asciiData(true, "i#d$");
    Label key = asciiData(true, "k!jp");
    run("decrypt_block", cipherblock, key);
    Assert.assertEquals(424232271, get(v0));
  }

  @Test
  public void verify_decrypt_1() {
    Label cipher = asciiData(false, "hellooye");
    Label key = asciiData(false, "bH@pz0()");
    Label original = emptyBytes(8);
    run("decrypt", cipher, key, 8, original);
    byte[] cipherBytes = getBytes(cipher, 0, 8);
    byte[] keyBytes = getBytes(key, 0, 8);
    byte[] originalBytes = getBytes(original, 0, 8);
    for(int i=1; i <= 2; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_decrypt_2() {
    Label cipher = asciiData(false, "r@stapop^loush>;");
    Label key = asciiData(false, "g&/]!#oxalo**qst");
    Label original = emptyBytes(16);
    run("decrypt", cipher, key, 16, original);
    byte[] cipherBytes = getBytes(cipher, 0, 16);
    byte[] keyBytes = getBytes(key, 0, 16);
    byte[] originalBytes = getBytes(original, 0, 16);
    for(int i=1; i <= 4; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_decrypt_3() {
    Label cipher = asciiData(false, "-sa@#f9#a0$9n#fh9cdjkdj0h4b2");
    Label key = asciiData(false, "#oxalo**qst9djdhn$sh6sd3DfFG");
    Label original = emptyBytes(28);
    run("decrypt", cipher, key, 28, original);
    byte[] cipherBytes = getBytes(cipher, 0, 28);
    byte[] keyBytes = getBytes(key, 0, 28);
    byte[] originalBytes = getBytes(original, 0, 28);
    for(int i=1; i <= 7; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_decrypt_4() {
    Label cipher = asciiData(false, "-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo");
    Label key = asciiData(false, "#oxalo**qst9djdhn$sh6sd3DfFG-sa@qst9");
    Label original = emptyBytes(36);
    run("decrypt", cipher, key, 36, original);
    byte[] cipherBytes = getBytes(cipher, 0, 36);
    byte[] keyBytes = getBytes(key, 0, 36);
    byte[] originalBytes = getBytes(original, 0, 36);
    for(int i=1; i <= 9; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_decrypt_5() {
    Label cipher = asciiData(false, "~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0");
    Label key = asciiData(false, "#oxalo**qst9djdhn$sh6sd3DfFG-sa@qst9^t^y");
    Label original = emptyBytes(40);
    run("decrypt", cipher, key, 40, original);
    byte[] cipherBytes = getBytes(cipher, 0, 40);
    byte[] keyBytes = getBytes(key, 0, 40);
    byte[] originalBytes = getBytes(original, 0, 40);
    for(int i=1; i <= 10; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_decrypt_6() {
    Label cipher = asciiData(false, "~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0");
    Label key = asciiData(false, "#oxalo**qst9djdh~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0n$sh6sd3DfFG-sa@qst9^t^y");
    Label original = emptyBytes(80);
    run("decrypt", cipher, key, 80, original);
    byte[] cipherBytes = getBytes(cipher, 0, 80);
    byte[] keyBytes = getBytes(key, 0, 80);
    byte[] originalBytes = getBytes(original, 0, 80);
    for(int i=1; i <= 20; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_decrypt_7() {
    Label cipher = asciiData(false, "~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:#oxalo**qst9djdhn$sh6sd3DfFG0~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0");
    Label key = asciiData(false, "#oxalo**qst9djdh~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0n$sh6sd3Df-sa@#f9#a0$9n#fh9cdjkdj0h4b2FG-sa@qst9^t^y");
    Label original = emptyBytes(108);
    run("decrypt", cipher, key, 108, original);
    byte[] cipherBytes = getBytes(cipher, 0, 108);
    byte[] keyBytes = getBytes(key, 0, 108);
    byte[] originalBytes = getBytes(original, 0, 108);
    for(int i=1; i <= 27; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_decrypt_8() {
    Label cipher = asciiData(false, "~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:#oxalo**qst9djdhn$sh6sd3DfFG0~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0=+Jo:#oxalo**qst9djdhn$sh6sd3DfFG0~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0");
    Label key = asciiData(false, "#oxalo**qst9djdh~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0n$sh6sd3Df-sa@#f9#a0$9n#fh9cdjkdj0h#oxalo**qst9djdh~/-sa@#f9#a0$)N#fh9cdjkdj0!9y12w>K=+Jo:0n$sh6sd3Df-sa@#f9#a0$9n#fh9cdjkdj0h4b2FG-sa@qst9^t^y4b2FG-sa@qst9^t^y");
    Label original = emptyBytes(216);
    run("decrypt", cipher, key, 216, original);
    byte[] cipherBytes = getBytes(cipher, 0, 216);
    byte[] keyBytes = getBytes(key, 0, 216);
    byte[] originalBytes = getBytes(original, 0, 216);
    for(int i=1; i <= 54; i++) {
      for(int j = (i*4)-1, k=(i*4)-4; j>=(i*4)-4 && k<i*4;j--,k++) {
        Assert.assertEquals("Block " + i + " decryption does not match expected result!", ((cipherBytes[j])^(keyBytes[k])), originalBytes[k]);
      }
    }
  }

  @Test
  public void verify_substr_1() {
    Label msg = asciiData(true, "rastapopulous");
    set(v0, 202);
    run("substr", msg, 2, 6);
    Assert.assertEquals(0, get(v0));
    Assert.assertEquals("stap", getString(msg, 0));
  }

  @Test
  public void verify_substr_2() {
    Label msg = asciiData(true, "severus snape");
    set(v0, 404);
    run("substr", msg, 0, 9);
    Assert.assertEquals(0, get(v0));
    Assert.assertEquals("severus s", getString(msg, 0));
  }

  @Test
  public void verify_substr_3() {
    Label msg = asciiData(true, "kafkaesque");
    set(v0, 414);
    run("substr", msg, 5, 10);
    Assert.assertEquals(0, get(v0));
    Assert.assertEquals("esque", getString(msg, 0));
  }

  @Test
  public void verify_substr_4() {
    Label msg = asciiData(true, "Toni Morrison");
    set(v0, 500);
    run("substr", msg, 8, 20);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals("Toni Morrison", getString(msg, 0, 13));
  }

  @Test
  public void verify_substr_5() {
    Label msg = asciiData(true, "Rabindranath Tagore");
    set(v0, 503);
    run("substr", msg, -1, 10);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals("Rabindranath Tagore", getString(msg, 0, 19));
  }
}
