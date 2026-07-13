package ma.android.eventchallenge

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout

/**
 * Ecran 1 : Click et LongClick
 */
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val activity1 = findViewById<ConstraintLayout>(R.id.activity1)
        val click = findViewById<Button>(R.id.click)
        val longText = findViewById<TextView>(R.id.longText)

        click.setOnClickListener {
            Toast.makeText(this, "Button click", Toast.LENGTH_SHORT).show()
            longText.text = "Simple Click On Button"
        }

        click.setOnLongClickListener {
            Toast.makeText(this@MainActivity, "Button Long click", Toast.LENGTH_SHORT).show()
            longText.text = "Long Click On Button"
            true
        }

        // Navigation par swipe : glisser à gauche pour passer à l'écran suivant
        activity1.setOnTouchListener(object : OnSwipeTouchListener(this) {
            override fun onSwipeLeft() {
                startActivity(Intent(this@MainActivity, MainActivity2::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
            }
        })
    }
}
