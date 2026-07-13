package ma.android.eventchallenge

import android.content.Intent
import android.os.Bundle
import android.view.MotionEvent
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout

/**
 * Ecran 5 : OnTouch (ACTION_DOWN / ACTION_MOVE / ACTION_UP)
 */
class MainActivity5 : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main5)

        val activity5 = findViewById<ConstraintLayout>(R.id.activity5)
        val touchArea = findViewById<TextView>(R.id.touchArea)
        val touchStatus = findViewById<TextView>(R.id.touchStatus)

        touchArea.setOnTouchListener { _, event ->
            val action = when (event.action) {
                MotionEvent.ACTION_DOWN -> "ACTION_DOWN"
                MotionEvent.ACTION_MOVE -> "ACTION_MOVE"
                MotionEvent.ACTION_UP -> "ACTION_UP"
                else -> "AUTRE"
            }
            touchStatus.text = "Event : $action   X=${event.x.toInt()}  Y=${event.y.toInt()}"
            true
        }

        activity5.setOnTouchListener(object : OnSwipeTouchListener(this) {
            override fun onSwipeLeft() {
                startActivity(Intent(this@MainActivity5, MainActivity6::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
            }

            override fun onSwipeRight() {
                startActivity(Intent(this@MainActivity5, MainActivity4::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
                finish()
            }
        })
    }
}
