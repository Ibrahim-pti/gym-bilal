<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\Member;
use Illuminate\Http\Request;
use Carbon\Carbon;

class AttendanceController extends Controller
{
    public function index()
    {
        $attendances = Attendance::with('member')->latest('check_in')->paginate(15);
        $members = Member::all();
        return view('attendances.index', compact('attendances', 'members'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'member_id' => 'nullable|exists:members,id',
            'barcode' => 'nullable|string',
        ]);

        $member = null;
        if ($request->member_id) {
            $member = Member::findOrFail($request->member_id);
        } elseif ($request->barcode) {
            $member = Member::where('barcode', $request->barcode)->first();
        }

        if (!$member) {
            return redirect()->back()->with('error', 'Member not found.');
        }

        // Check if member already checked in today without check out
        $activeAttendance = Attendance::where('member_id', $member->id)
            ->whereDate('check_in', Carbon::today())
            ->whereNull('check_out')
            ->first();

        if ($activeAttendance) {
            // Auto check-out if scanning again
            $activeAttendance->update(['check_out' => now()]);
            return redirect()->back()->with('success', $member->name . ' - ' . __('messages.check_out_success'));
        }

        Attendance::create([
            'member_id' => $member->id,
            'check_in' => now(),
        ]);

        return redirect()->back()->with('success', $member->name . ' - ' . __('messages.check_in_success'));
    }

    public function update(Request $request, Attendance $attendance)
    {
        if ($attendance->check_out) {
            return redirect()->back()->with('error', __('messages.already_checked_out', ['default' => 'Member already checked out.']));
        }

        $attendance->update([
            'check_out' => now(),
        ]);

        return redirect()->back()->with('success', __('messages.check_out_success', ['default' => 'Checked out successfully.']));
    }

    public function destroy(Attendance $attendance)
    {
        $attendance->delete();
        return redirect()->back()->with('success', __('messages.attendance_deleted', ['default' => 'Attendance deleted.']));
    }
}
