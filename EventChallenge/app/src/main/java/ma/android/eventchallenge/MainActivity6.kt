package ma.android.eventchallenge

import android.app.DatePickerDialog
import android.content.Intent
import android.os.Bundle
import android.view.ContextMenu
import android.view.MenuItem
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import java.util.Calendar

/**
 * Ecran 6 : CreateContextMenu (menu contextuel) et OnDateSet (DatePickerDialog)
 */
class MainActivity6 : AppCompatActivity() {

    private lateinit var resultText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main6)

        val activity6 = findViewById<ConstraintLayout>(R.id.activity6)
        val contextButton = findViewById<Button>(R.id.buttonContextMenu)
        val dateButton = findViewById<Button>(R.id.buttonDatePicker)
        resultText = findViewById(R.id.textResult6)

        // Enregistre le bouton pour qu'il déclenche onCreateContextMenu lors d'un appui long
        registerForContextMenu(contextButton)
        contextButton.setOnClickListener {
            Toast.makeText(this, "Faites un appui long pour ouvrir le menu", Toast.LENGTH_SHORT).show()
        }

        dateButton.setOnClickListener {
            val calendar = Calendar.getInstance()
            val year = calendar.get(Calendar.YEAR)
            val month = calendar.get(Calendar.MONTH)
            val day = calendar.get(Calendar.DAY_OF_MONTH)

            DatePickerDialog(this, { _, selectedYear, selectedMonth, selectedDay ->
                // ceci est le listener OnDateSetListener
                resultText.text = "Date sélectionnée : $selectedDay/${selectedMonth + 1}/$selectedYear"
            }, year, month, day).show()
        }

        activity6.setOnTouchListener(object : OnSwipeTouchListener(this) {
            override fun onSwipeRight() {
                startActivity(Intent(this@MainActivity6, MainActivity5::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
                finish()
            }
        })
    }

    override fun onCreateContextMenu(menu: ContextMenu, v: View, menuInfo: ContextMenu.ContextMenuInfo?) {
        super.onCreateContextMenu(menu, v, menuInfo)
        menu.setHeaderTitle("Menu Contextuel")
        menu.add(0, 1, 0, "Option 1")
        menu.add(0, 2, 1, "Option 2")
        menu.add(0, 3, 2, "Option 3")
    }

    override fun onContextItemSelected(item: MenuItem): Boolean {
        resultText.text = "Item sélectionné : ${item.title}"
        return true
    }
}
