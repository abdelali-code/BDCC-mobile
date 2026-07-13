package ma.android.eventchallenge

import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout

/**
 * Ecran 3 : TextChange (addTextChangedListener)
 */
class MainActivity3 : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main3)

        val activity3 = findViewById<ConstraintLayout>(R.id.activity3)
        val editText = findViewById<EditText>(R.id.editTextChange)
        val resultText = findViewById<TextView>(R.id.textChangeResult)

        editText.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                resultText.text = "Texte : ${s.toString()}\nNombre de caractères : ${s?.length ?: 0}"
            }

            override fun afterTextChanged(s: Editable?) {}
        })

        activity3.setOnTouchListener(object : OnSwipeTouchListener(this) {
            override fun onSwipeLeft() {
                startActivity(Intent(this@MainActivity3, MainActivity4::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
            }

            override fun onSwipeRight() {
                startActivity(Intent(this@MainActivity3, MainActivity2::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
                finish()
            }
        })
    }
}
