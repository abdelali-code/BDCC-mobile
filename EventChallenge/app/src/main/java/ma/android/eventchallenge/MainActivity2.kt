package ma.android.eventchallenge

import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout

/**
 * Ecran 2 : Swipe (gauche / droite) - sert aussi de navigation entre écrans
 */
class MainActivity2 : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main2)

        val activity2 = findViewById<ConstraintLayout>(R.id.activity2)
        val statusText = findViewById<TextView>(R.id.swipeStatus)

        activity2.setOnTouchListener(object : OnSwipeTouchListener(this) {
            override fun onSwipeLeft() {
                statusText.text = "Swipe Left détecté"
                startActivity(Intent(this@MainActivity2, MainActivity3::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
            }

            override fun onSwipeRight() {
                statusText.text = "Swipe Right détecté"
                startActivity(Intent(this@MainActivity2, MainActivity::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
                finish()
            }
        })
    }
}
